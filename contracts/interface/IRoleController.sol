// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IRoleController {
    function isManager(address _account) external view returns (bool);
}
