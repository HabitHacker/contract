// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";

contract RoleController is AccessControlEnumerableUpgradeable {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");

    uint256 public moderatorCount;
    mapping(address => uint256) public warningCount;

    function __RoleController_init() internal initializer {
        __AccessControlEnumerable_init();
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    modifier onlyAdmin() {
        require(
            hasRole(ADMIN_ROLE, msg.sender),
            "RoleManager: must have admin role"
        );
        _;
    }

    modifier onlyManager() {
        require(
            hasRole(MANAGER_ROLE, msg.sender) ||
                hasRole(ADMIN_ROLE, msg.sender),
            "RoleManager: must have manager role"
        );
        _;
    }

    modifier onlyModerator() {
        require(
            hasRole(MODERATOR_ROLE, msg.sender) ||
                hasRole(MANAGER_ROLE, msg.sender) ||
                hasRole(ADMIN_ROLE, msg.sender),
            "RoleManager: must have moderator role"
        );
        _;
    }

    modifier onlyRelayer() {
        require(
            hasRole(RELAYER_ROLE, msg.sender),
            "RoleManager: must have relayer role"
        );
        _;
    }

    function addAdmin(address account) public onlyAdmin {
        _grantRole(ADMIN_ROLE, account);
    }

    function addManager(address account) public onlyAdmin {
        _grantRole(MANAGER_ROLE, account);
    }

    function addModerator(address account) public onlyManager {
        _grantRole(MODERATOR_ROLE, account);
        moderatorCount++;
    }

    function addRelayer(address account) public onlyAdmin {
        _grantRole(RELAYER_ROLE, account);
    }

    function removeAdmin(address account) public onlyAdmin {
        _revokeRole(ADMIN_ROLE, account);
    }

    function removeManager(address account) public onlyAdmin {
        _revokeRole(MANAGER_ROLE, account);
    }

    function removeModerator(address account) public onlyManager {
        _revokeRole(MODERATOR_ROLE, account);
        moderatorCount--;
    }

    function removeRelayer(address account) public onlyAdmin {
        _revokeRole(RELAYER_ROLE, account);
    }

    function getAdmins() public view returns (address[] memory) {
        uint256 length = getRoleMemberCount(ADMIN_ROLE);
        address[] memory admins = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            admins[i] = getRoleMember(ADMIN_ROLE, i);
        }
        return admins;
    }

    function getManagers() public view returns (address[] memory) {
        uint256 length = getRoleMemberCount(MANAGER_ROLE);
        address[] memory managers = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            managers[i] = getRoleMember(MANAGER_ROLE, i);
        }
        return managers;
    }

    function getModerators() public view returns (address[] memory) {
        uint256 length = getRoleMemberCount(MODERATOR_ROLE);
        address[] memory moderators = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            moderators[i] = getRoleMember(MODERATOR_ROLE, i);
        }
        return moderators;
    }

    function getRelayers() public view returns (address[] memory) {
        uint256 length = getRoleMemberCount(RELAYER_ROLE);
        address[] memory relayers = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            relayers[i] = getRoleMember(RELAYER_ROLE, i);
        }
        return relayers;
    }

    function isRelayer(address account) public view returns (bool) {
        return hasRole(RELAYER_ROLE, account);
    }

    function isModerator(address account) public view returns (bool) {
        return hasRole(MODERATOR_ROLE, account);
    }

    function isManager(address account) public view returns (bool) {
        return hasRole(MANAGER_ROLE, account);
    }

    function isAdmin(address account) public view returns (bool) {
        return hasRole(ADMIN_ROLE, account);
    }

    uint256[48] private __gap;
}
