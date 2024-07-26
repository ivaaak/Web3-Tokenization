// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Marketplace is ReentrancyGuard {
    IERC721 public nftContract;

    struct Listing {
        address seller;
        uint256 price;
    }

    mapping(uint256 => Listing) public listings;

    event ItemListed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event ItemSold(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price);

    constructor(address _tokenAddress) {
        nftContract = IERC721(_tokenAddress);
    }

    function listItem(uint256 tokenId, uint256 price) external {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than zero");
        require(nftContract.getApproved(tokenId) == address(this), "Marketplace not approved");

        listings[tokenId] = Listing(msg.sender, price);

        emit ItemListed(tokenId, msg.sender, price);
    }

    function cancelListing(uint256 tokenId) external {
        require(listings[tokenId].seller == msg.sender, "Not the seller");

        delete listings[tokenId];
    }

    function buyItem(uint256 tokenId) external payable nonReentrant {
        Listing memory item = listings[tokenId];
        require(item.price > 0, "Item not listed");
        require(msg.value >= item.price, "Insufficient payment");

        delete listings[tokenId];

        nftContract.safeTransferFrom(item.seller, msg.sender, tokenId);

        (bool sent, ) = payable(item.seller).call{value: item.price}("");
        require(sent, "Failed to send Ether");

        if (msg.value > item.price) {
            (bool refundSent, ) = payable(msg.sender).call{value: msg.value - item.price}("");
            require(refundSent, "Failed to refund excess");
        }

        emit ItemSold(tokenId, msg.sender, item.seller, item.price);
    }

    function getItemPrice(uint256 tokenId) external view returns (uint256) {
        return listings[tokenId].price;
    }
}