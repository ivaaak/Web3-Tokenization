// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Diamond is Ownable {
    event DiamondCut(address indexed _facet, bytes4[] _functionSelectors);

    mapping(bytes4 => address) private _selectorToFacetMap;

    constructor(address _diamondCutFacet) {
        _transferOwnership(msg.sender);
        _addFacet(_diamondCutFacet, [bytes4(keccak256("diamondCut(address,bytes4[],address,bytes)"))]);
    }

    fallback() external payable {
        address facet = _selectorToFacetMap[msg.sig];
        require(facet != address(0), "Diamond: Function does not exist");

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}

    function _addFacet(address _facet, bytes4[] memory _selectors) internal onlyOwner {
        for (uint i = 0; i < _selectors.length; i++) {
            _selectorToFacetMap[_selectors[i]] = _facet;
        }
        emit DiamondCut(_facet, _selectors);
    }
}