// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "../interface/IHabitCollection.sol";

contract HabitCollectionFactory {
    using Clones for address;

    address public habitCollectionTemplate;

    function createCollection(
        uint256 habitId,
        string memory name,
        string memory baseURI
    ) public {
        address _collectionaddress = habitCollectionTemplate.cloneDeterministic(
            getSalt(habitId)
        );
        IHabitCollection(_collectionaddress).initialize(
            habitId,
            name,
            name,
            baseURI
        );
    }

    function getSalt(uint256 habitId) public pure returns (bytes32) {
        return bytes32(abi.encodePacked(habitId));
    }

    function predictCollectionAddress(
        uint256 habitId
    ) public view returns (address) {
        return
            habitCollectionTemplate.predictDeterministicAddress(
                getSalt(habitId)
            );
    }

    uint256[49] private __gap;
}
