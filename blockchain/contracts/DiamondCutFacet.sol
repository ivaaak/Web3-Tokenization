// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DiamondCutFacet is Ownable {
    enum FacetCutAction {Add, Replace, Remove}

    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }

    event DiamondCut(FacetCut[] _diamondCut, address _init, bytes _calldata);

    mapping(bytes4 => address) public facets;

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external onlyOwner {
        for (uint i = 0; i < _diamondCut.length; i++) {
            FacetCut memory cut = _diamondCut[i];
            if (cut.action == FacetCutAction.Add) {
                addFunctions(cut.facetAddress, cut.functionSelectors);
            } else if (cut.action == FacetCutAction.Replace) {
                replaceFunctions(cut.facetAddress, cut.functionSelectors);
            } else if (cut.action == FacetCutAction.Remove) {
                removeFunctions(cut.facetAddress, cut.functionSelectors);
            } else {
                revert("DiamondCutFacet: Invalid FacetCutAction");
            }
        }

        emit DiamondCut(_diamondCut, _init, _calldata);

        if (_init != address(0)) {
            (bool success, ) = _init.delegatecall(_calldata);
            require(success, "DiamondCutFacet: Init function reverted");
        }
    }

    function addFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        for (uint i = 0; i < _functionSelectors.length; i++) {
            require(facets[_functionSelectors[i]] == address(0), "DiamondCutFacet: Function already exists");
            facets[_functionSelectors[i]] = _facetAddress;
        }
    }

    function replaceFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        for (uint i = 0; i < _functionSelectors.length; i++) {
            require(facets[_functionSelectors[i]] != address(0), "DiamondCutFacet: Function doesn't exist");
            require(facets[_functionSelectors[i]] != _facetAddress, "DiamondCutFacet: Can't replace function with same facet");
            facets[_functionSelectors[i]] = _facetAddress;
        }
    }

    function removeFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        for (uint i = 0; i < _functionSelectors.length; i++) {
            require(facets[_functionSelectors[i]] != address(0), "DiamondCutFacet: Function doesn't exist");
            delete facets[_functionSelectors[i]];
        }
    }
}