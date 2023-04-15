// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IHabitCollection {
    function initialize(
        uint256 _challengeId,
        string memory _name,
        string memory _symbol,
        string memory baseURI_
    ) external;

    function mint(address _to) external;

    function burn(uint256 _tokenId) external;
}
