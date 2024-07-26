// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TokenizeAsset is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct ItemMetadata {
        string name;
        string description;
        string imageUri;
        string modelUri;  // For 3D scan data
        mapping(string => string) additionalData;
    }

    mapping(uint256 => ItemMetadata) private _tokenMetadata;

    constructor() ERC721("TokenizeAsset", "PNFT") {}

    function mintToken(
        address recipient,
        string memory name,
        string memory description,
        string memory imageUri,
        string memory modelUri
    ) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        require(!_exists(newTokenId), "Token already exists");

        // Prepare metadata
        ItemMetadata storage newItem = _tokenMetadata[newTokenId];
        newItem.name = name;
        newItem.description = description;
        newItem.imageUri = imageUri;
        newItem.modelUri = modelUri;

        // Mint the token
        _safeMint(recipient, newTokenId);

        return newTokenId;
    }

    function addAdditionalData(uint256 tokenId, string memory key, string memory value) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        _tokenMetadata[tokenId].additionalData[key] = value;
    }

    function getMetadata(uint256 tokenId) public view returns (
        string memory name,
        string memory description,
        string memory imageUri,
        string memory modelUri
    ) {
        require(_exists(tokenId), "Token does not exist");
        ItemMetadata storage item = _tokenMetadata[tokenId];
        return (item.name, item.description, item.imageUri, item.modelUri);
    }

    function getAdditionalData(uint256 tokenId, string memory key) public view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenMetadata[tokenId].additionalData[key];
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        // In a real-world scenario, you'd generate a JSON metadata file here
        // and return its URI, potentially using IPFS or another decentralized storage
        return "";
    }
}