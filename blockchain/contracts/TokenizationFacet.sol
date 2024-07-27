// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TokenizationFacet is ERC721, Ownable {
    using Counters for Counters.Counter;

    struct Item {
        string name;
        uint256 creationTime;
    }

    Counters.Counter private _tokenIds;
    mapping(uint256 => Item) private _items;

    event ItemMinted(uint256 indexed tokenId, string name, address indexed owner);

    constructor() ERC721("MyToken", "MTK") {}

    function mintItem(address to, string memory name) external onlyOwner returns (uint256) {
        require(bytes(name).length > 0, "TokenizationFacet: Name cannot be empty");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _safeMint(to, newItemId);
        _items[newItemId] = Item(name, block.timestamp);

        emit ItemMinted(newItemId, name, to);

        return newItemId;
    }

    function getItem(uint256 tokenId) external view returns (Item memory) {
        require(_exists(tokenId), "TokenizationFacet: Item does not exist");
        return _items[tokenId];
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "TokenizationFacet: URI query for nonexistent token");

        // In a real-world scenario, you would generate a proper URI here
        // This is just a placeholder
        return string(abi.encodePacked("https://myapi.com/token/", Strings.toString(tokenId)));
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }
}