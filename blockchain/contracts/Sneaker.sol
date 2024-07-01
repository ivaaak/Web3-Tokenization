contract SneakerToken is ERC721URIStorage {
    struct SneakerDetails {
        string brand;
        string model;
        string size;
        string condition;
        string serialNumber;
        bool isAuthenticated;
    }

    mapping(uint256 => SneakerDetails) public sneakerDetails;

    function mintAuthenticatedSneaker(
        address recipient, 
        string memory tokenURI, 
        string memory brand,
        string memory model,
        string memory size,
        string memory condition,
        string memory serialNumber
    ) public onlyAuthenticator returns (uint256) {
        uint256 tokenId = _mintSneaker(recipient, tokenURI);
        sneakerDetails[tokenId] = SneakerDetails(brand, model, size, condition, serialNumber, true);
        return tokenId;
    }

    function validateAuthenticity(uint256 tokenId) public view returns (bool) {
        return sneakerDetails[tokenId].isAuthenticated;
    }

    // Add necessary access control modifiers
}