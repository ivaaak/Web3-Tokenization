contract SneakerMarketplace {
    SneakerToken public sneakerToken;

    struct Listing {
        uint256 tokenId;
        uint256 price;
        address seller;
    }

    mapping(uint256 => Listing) public listings;

    function listSneaker(uint256 tokenId, uint256 price) public {
        require(sneakerToken.ownerOf(tokenId) == msg.sender, "Not the owner");
        sneakerToken.transferFrom(msg.sender, address(this), tokenId);
        listings[tokenId] = Listing(tokenId, price, msg.sender);
    }

    function buySneaker(uint256 tokenId) public payable {
        Listing memory listing = listings[tokenId];
        require(msg.value >= listing.price, "Insufficient payment");
        
        sneakerToken.transferFrom(address(this), msg.sender, tokenId);
        payable(listing.seller).transfer(listing.price);
        
        // Refund excess payment
        if (msg.value > listing.price) {
            payable(msg.sender).transfer(msg.value - listing.price);
        }

        delete listings[tokenId];
    }
}