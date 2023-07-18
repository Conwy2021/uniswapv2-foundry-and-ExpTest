// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {MerkleVerifier2} from "src/expand/MerkleVerifier.sol";
contract A {
  function At() public  {
    bytes32 aHash = bytes32("aaaa");
    
    bytes32 computedRoot = MerkleVerifier2._hashPair(aHash, aHash);
  }
}
