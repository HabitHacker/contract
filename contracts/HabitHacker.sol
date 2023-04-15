// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./libs/HabitCore.sol";
import "./interface/IHabitCollection.sol";

contract HabitHacker is Initializable, HabitCore {
    function initialize(
        uint256 _moderatorRequireAmount,
        uint256 _platformFee
    ) public initializer {
        __RoleController_init();
        moderatorRequireAmount = _moderatorRequireAmount;
        platformFee = _platformFee;
    }

    /**
     * @notice Set the habit information
     * @param habitId Identifier to identify habit
     * @param _habitInfo Habit information
     * @param collectionName Name of the collection
     * @param baseURI Base URI of the collection
     */
    function habitSetting(
        uint256 habitId,
        HabitInfo memory _habitInfo,
        string memory collectionName,
        string memory baseURI
    ) public onlyRelayer {
        habitInfo[habitId] = _habitInfo;
        createCollection(habitId, collectionName, baseURI);
    }

    /**
     * @notice Function that allows you to bat a certain amount of money and participate in a particular habit
     * @param habitId Identifier to identify habit
     */
    function participate(uint256 habitId) public payable {
        require(
            habitInfo[habitId].maxParticipants > participants[habitId].length,
            "participants are full"
        );
        require(
            habitInfo[habitId].startTime <= block.timestamp &&
                block.timestamp <= habitInfo[habitId].endTime,
            "habit is not available"
        );
        // not allowed to participate twice
        require(bettingAmount[habitId][msg.sender] == 0, "Can't participate");

        require(
            habitInfo[habitId].minBettingPrice <= msg.value &&
                msg.value <= habitInfo[habitId].maxBettingPrice,
            "price is not proper"
        );

        payable(address(this)).transfer(msg.value);

        bettingAmount[habitId][msg.sender] += msg.value;
        participants[habitId].push(msg.sender);
        totalBettingAmount[habitId] += msg.value;
        participatedHabitIds[msg.sender].push(habitId);
    }

    /**
     * @notice Functions that receive validated informations to increase executeCount and verifyCount
     * @dev This function is called by the relayer
     * @param moderator Moderator participating in validation
     * @param verifyUnits Array of units to verify
     */
    function verify(
        address moderator,
        VerifyUnit[] memory verifyUnits
    ) public onlyRelayer {
        for (uint256 i = 0; i < verifyUnits.length; i++) {
            uint256 habitId = verifyUnits[i].habitId;
            address user = verifyUnits[i].user;
            uint256 index = verifyUnits[i].index;
            bytes32 calculatedHash = keccak256(
                abi.encodePacked(
                    uint256(uint160(moderator)),
                    uint256(habitId),
                    uint256(uint160(user)),
                    uint256(index)
                )
            );
            require(excuteHash[calculatedHash] == 0, "already verified");

            require(bettingAmount[habitId][user] > 0, "invalid user");

            verifiedCount[habitId][user][index] += 1;
            if (verifiedCount[habitId][user][index] == moderatorCount / 2) {
                excuteCount[habitId][user] += 1;
            }
            verifyCount[habitId][moderator] += 1;
            excuteHash[calculatedHash] = 1;
            emit Verified(habitId, user, index);
        }
    }

    /**
     * @notice Function that settles the winner, drawer, loser and distributes the prize
     * @notice Winner takes not only the bet amount but also the loser amount as much as the bet rate
     * @notice Drawer will receive the amount of bet
     * @notice Loser is paid a certain percentage of the bet amount
     * @notice The moderator is paid as many times as he has verified
     * @param habitId Identifier to identify habit
     */
    function settleWinner(uint256 habitId) public payable {
        require(
            habitInfo[habitId].endTime < block.timestamp,
            "habit is not over"
        );
        uint256 spentAmount = 0;
        uint256 totalAmount = totalBettingAmount[habitId];

        unchecked {
            HabitInfo memory _habitInfo = habitInfo[habitId];
            uint256 lostAmount = 0;
            uint256 winnerCount = 0;
            address[100] memory winners;
            address[] memory _participants = participants[habitId];

            for (uint256 i = 0; i < _participants.length; i++) {
                uint256 _excuteCount = excuteCount[habitId][_participants[i]];
                if (_excuteCount == _habitInfo.successCondition) {
                    // Temporary saving of successful users
                    winners[winnerCount] = _participants[i];
                    winnerCount++;
                } else if (_excuteCount >= _habitInfo.drawCondition) {
                    /**
                     * ==============
                     * Drawer
                     * ==============
                     */
                    payable(_participants[i]).transfer(
                        bettingAmount[habitId][_participants[i]]
                    );
                    spentAmount += bettingAmount[habitId][_participants[i]];
                } else {
                    /**
                     * ==============
                     * Loser
                     * ==============
                     */
                    payable(_participants[i]).transfer(
                        (bettingAmount[habitId][_participants[i]] *
                            _habitInfo.failersRetrieveRatio) / 100
                    );
                    spentAmount +=
                        (bettingAmount[habitId][_participants[i]] *
                            _habitInfo.failersRetrieveRatio) /
                        100;
                    lostAmount +=
                        (bettingAmount[habitId][_participants[i]] *
                            (100 - _habitInfo.failersRetrieveRatio)) /
                        100;
                }
            }
            /**
             * ==============
             * Winner
             * ==============
             */
            address _winnerCollectionAddress = predictCollectionAddress(
                habitId
            );
            for (uint256 i = 0; i < winnerCount; i++) {
                // Winner takes not only the bet amount but also the loser amount as much as the bet rate
                payable(winners[i]).transfer(
                    bettingAmount[habitId][winners[i]] +
                        (lostAmount * bettingAmount[habitId][winners[i]]) /
                        totalAmount
                );
                IHabitCollection(_winnerCollectionAddress).mint(winners[i]);
                spentAmount +=
                    bettingAmount[habitId][winners[i]] +
                    (lostAmount * bettingAmount[habitId][winners[i]]) /
                    totalAmount;
            }
        }
        /**
         * ==============
         * Moderator
         * ==============
         */
        address[] memory moderators = getModerators();
        uint256 verifyCountSum;

        unchecked {
            for (uint256 i = 0; i < moderators.length; i++) {
                verifyCountSum += verifyCount[habitId][moderators[i]];
            }
            for (uint256 i = 0; i < moderators.length; i++) {
                payable(moderators[i]).transfer(
                    ((totalAmount - spentAmount) *
                        (verifyCount[habitId][moderators[i]]) *
                        (100 - platformFee)) / (verifyCountSum * 100)
                );
            }
        }
    }

    /**
     * ==============================
     * Get functions
     * ==============================
     */

    function getParticipantsNum(uint256 habitId) public view returns (uint256) {
        return participants[habitId].length;
    }

    function getBettingAmount(
        uint256 habitId,
        address user
    ) public view returns (uint256) {
        return bettingAmount[habitId][user];
    }

    function getHabitsForUser(
        address user
    ) public view returns (uint256[] memory) {
        return participatedHabitIds[user];
    }

    function getHabitInfo(
        uint256 habitId
    ) public view returns (HabitInfo memory) {
        return habitInfo[habitId];
    }

    receive() external payable {}

    uint256[50] private __gap;
}
