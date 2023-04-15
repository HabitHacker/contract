// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "./utils/ContractFactory.sol";

contract HabitCollection is ERC721Upgradeable, ContractFactory {
    uint256 public challengeId;
    uint256 public nextTokenId;
    string baseURI;

    /**
     * @notice Initialize the template's immutable variables.
     * @param _contractFactory The factory which will be used to create collection contracts.
     */
    constructor(
        address _contractFactory
    )
        ContractFactory(_contractFactory) // solhint-disable-next-line no-empty-blocks
    {}

    function initialize(
        uint256 _challengeId,
        string memory _name,
        string memory _symbol,
        string memory baseURI_
    ) public initializer onlyContractFactory {
        __ERC721_init(_name, _symbol);
        challengeId = _challengeId;
        nextTokenId = 1;
        baseURI = baseURI_;
    }

    function mint(address _to) public onlyContractFactory {
        _mint(_to, nextTokenId);
        nextTokenId++;
    }

    function burn(uint256 _tokenId) public {
        require(
            _isApprovedOrOwner(_msgSender(), _tokenId),
            "caller is not owner nor approved"
        );
        _burn(_tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}
