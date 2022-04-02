// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @custom:security-contact lourenslinde@gmail.com
contract Guidler is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Strings for uint256;
    using HexStrings for uint160;
    using ToColor for bytes3;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    IERC20 private token;

    /// Mapping of the tokenId to uint256 representing seconds since last harvest
    mapping(uint256 => uint256) public lastHarvest;

    constructor() ERC721("Guidler", "GDLR") {}

    function _baseURI() internal pure override returns (string memory) {
        return "placeholder";
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        lastHarvest[tokenId] = block.timestamp;
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /// Internal functions
    /// @notice Calculates the amount of BLSMS available for harvest
    /// @dev Subtracts the lastHarvest[tokenId] from block.timestamp and divdes by 6000
    /// @return BLSMS:uint256
    function availableYield(uint256 tokenId) internal pure returns(uint256) {
        return (block.timestamp - lastHarvest[tokenId])/6000;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}