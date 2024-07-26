// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DiamondLoupeFacet {
    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }

    // This should be the same storage layout as in DiamondCutFacet
    mapping(bytes4 => address) private facets;
    address[] private facetAddresses;
    mapping(address => bytes4[]) private facetFunctionSelectors;

    function facetAddress(bytes4 _functionSelector) external view returns (address) {
        return facets[_functionSelector];
    }

    function facetFunctionSelectors(address _facet) external view returns (bytes4[] memory) {
        return facetFunctionSelectors[_facet];
    }

    function facetAddresses() external view returns (address[] memory) {
        return facetAddresses;
    }

    function facets() external view returns (Facet[] memory facetsArray) {
        facetsArray = new Facet[](facetAddresses.length);
        for (uint i = 0; i < facetAddresses.length; i++) {
            address facetAddress = facetAddresses[i];
            facetsArray[i] = Facet(facetAddress, facetFunctionSelectors[facetAddress]);
        }
    }

    // This function should be called from DiamondCutFacet when adding a new facet
    function addFacet(address _facetAddress, bytes4[] memory _selectors) internal {
        for (uint i = 0; i < _selectors.length; i++) {
            facets[_selectors[i]] = _facetAddress;
        }
        facetAddresses.push(_facetAddress);
        facetFunctionSelectors[_facetAddress] = _selectors;
    }

    // This function should be called from DiamondCutFacet when removing a facet
    function removeFacet(address _facetAddress, bytes4[] memory _selectors) internal {
        for (uint i = 0; i < _selectors.length; i++) {
            delete facets[_selectors[i]];
        }
        for (uint i = 0; i < facetAddresses.length; i++) {
            if (facetAddresses[i] == _facetAddress) {
                facetAddresses[i] = facetAddresses[facetAddresses.length - 1];
                facetAddresses.pop();
                break;
            }
        }
        delete facetFunctionSelectors[_facetAddress];
    }
}