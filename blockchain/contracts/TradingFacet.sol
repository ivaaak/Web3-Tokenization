// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract TradingFacet is ReentrancyGuard {
    IERC721 public nftContract;

    struct Trade {
        uint256 itemId;
        address seller;
        uint256 price;
        bool isActive;
    }

    mapping(uint256 => Trade) public trades;
    uint256 public tradeCounter;

    event TradeCreated(uint256 indexed tradeId, uint256 indexed itemId, address indexed seller, uint256 price);
    event TradeCompleted(uint256 indexed tradeId, uint256 indexed itemId, address indexed buyer, uint256 price);
    event TradeCancelled(uint256 indexed tradeId, uint256 indexed itemId, address indexed seller);

    constructor(address _nftContract) {
        nftContract = IERC721(_nftContract);
    }

    function createTrade(uint256 _itemId, uint256 _price) external {
        require(nftContract.ownerOf(_itemId) == msg.sender, "You don't own this item");
        require(_price > 0, "Price must be greater than zero");

        tradeCounter++;
        trades[tradeCounter] = Trade(_itemId, msg.sender, _price, true);

        nftContract.transferFrom(msg.sender, address(this), _itemId);

        emit TradeCreated(tradeCounter, _itemId, msg.sender, _price);
    }

    function completeTrade(uint256 _tradeId) external payable nonReentrant {
        Trade storage trade = trades[_tradeId];
        require(trade.isActive, "Trade is not active");
        require(msg.value == trade.price, "Incorrect price");

        trade.isActive = false;

        nftContract.transferFrom(address(this), msg.sender, trade.itemId);
        payable(trade.seller).transfer(msg.value);

        emit TradeCompleted(_tradeId, trade.itemId, msg.sender, trade.price);
    }

    function cancelTrade(uint256 _tradeId) external {
        Trade storage trade = trades[_tradeId];
        require(trade.isActive, "Trade is not active");
        require(trade.seller == msg.sender, "Only the seller can cancel the trade");

        trade.isActive = false;

        nftContract.transferFrom(address(this), msg.sender, trade.itemId);

        emit TradeCancelled(_tradeId, trade.itemId, msg.sender);
    }

    function getTrade(uint256 _tradeId) external view returns (Trade memory) {
        return trades[_tradeId];
    }
}