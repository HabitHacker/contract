// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";
import "./RoleController.sol";
import "./HabitCollectionFactory.sol";
import "hardhat/console.sol";

contract HabitCore is RoleController, HabitCollectionFactory {
    using ECDSAUpgradeable for bytes32;

    // Amount required to register the moderator
    uint256 moderatorRequireAmount;
    // platform fee
    uint256 platformFee;

    /**
     * =================
     * Habit info
     * =================
     */
    // habitId => habitInfo
    mapping(uint256 => HabitInfo) public habitInfo;
    // habitId => participants
    mapping(uint256 => address[]) participants;
    // habitId => totalBettingAmount
    mapping(uint256 => uint256) public totalBettingAmount;

    /**
     * =================
     * User
     * =================
     */
    // habitId => user => excuteCount
    mapping(uint256 => mapping(address => uint256)) public excuteCount;
    // habitId => user => index => verifiedCount
    mapping(uint256 => mapping(address => mapping(uint256 => uint256)))
        public verifiedCount;
    // habitId => user => bettingAmount
    mapping(uint256 => mapping(address => uint256)) public bettingAmount;
    // hash to prevent duplicate verification
    // 0 => not used hash, 1 => used hash
    mapping(bytes32 => uint256) public excuteHash;
    // address => habitId[]
    mapping(address => uint256[]) public participatedHabitIds;

    /**
     * =================
     * Moderator
     * =================
     */
    // habitId => moderator => verifyCount
    mapping(uint256 => mapping(address => uint256)) public verifyCount;
    // habitId => moderator => verifyAmount
    mapping(address => uint256) public moderatorAmount;

    // Structure that contains information about the habit
    // 512 bits per game
    struct HabitInfo {
        // Maximum amount that can be bet on habit
        uint96 maxBettingPrice;
        // Minimum amount that can be bet on habit
        uint96 minBettingPrice;
        // Maximum number of participants
        uint24 maxParticipants;
        // The loser will be given back (failersRetrieveRatio/100)% of the bet amount to the betters.
        uint8 failersRetrieveRatio;
        // Number of executes to succeed
        uint16 successCondition;
        // Number of executes to draw
        uint16 drawCondition;
        // start time
        uint128 startTime;
        // end time
        uint128 endTime;
    }

    // The unit to verify
    struct VerifyUnit {
        uint256 habitId;
        address user;
        uint256 index;
    }

    // Events that occur when you verify
    event Verified(
        uint256 indexed habitId,
        address indexed user,
        uint256 indexed index
    );

    // Events that occur when the moderator is registered
    event ModeratorRegistered(address indexed moderator);

    /**
     * @notice If a particular user's verification is wrong, the number of verification of the user is reduced, the number of verifications of the wrong moderator is reduced, and the number of warnings of the wrong moderator is increased.
     * @param habitId Identifier to identify habit
     * @param addr Address of user
     * @param wrongModerators Array of wrong moderators
     * */
    function reduceExcuteCount(
        uint256 habitId,
        address addr,
        address[] memory wrongModerators
    ) public onlyManager {
        excuteCount[habitId][addr] -= 1;
        for (uint256 i = 0; i < wrongModerators.length; i++) {
            verifyCount[habitId][wrongModerators[i]] -= 1;
            warningCount[wrongModerators[i]] += 1;
        }
    }

    /**
     * @notice A function that stakes a certain amount of money and registers it as a moderator
     * @param relayerSignature Means for executing functions through a website
     * @dev If you maliciously receive only the signature and run it in ethercan, you are not eligible for moderator
     */
    function registerModerator(bytes memory relayerSignature) public payable {
        bytes32 messageOrigin = keccak256(
            abi.encodePacked(uint256(uint160(msg.sender)))
        ).toEthSignedMessageHash();

        address recovedRelayer = messageOrigin.recover(relayerSignature);
        require(isRelayer(recovedRelayer), "invalid relayer signature");

        require(msg.value == moderatorRequireAmount, "not proper amount");
        payable(address(this)).transfer(msg.value);
        moderatorAmount[msg.sender] += msg.value;

        _grantRole(MODERATOR_ROLE, msg.sender);
        moderatorCount += 1;

        emit ModeratorRegistered(msg.sender);
    }

    /**
     * @dev Called to sync if modulator is registered on another chain
     * @dev Catch the event and call each chain from the relayer server
     * @param addr Address of moderator
     */
    function resisterOtherChainModerator(address addr) public onlyRelayer {
        addModerator(addr);
    }

    /**
     * @notice Function to update the template address of the collection to be deployed
     * @param _habitCollectionTemplate Address of habit collection template
     */
    function updateCollectionTemplate(
        address _habitCollectionTemplate
    ) public onlyAdmin {
        habitCollectionTemplate = _habitCollectionTemplate;
    }

    uint256[42] private __gap;
}
