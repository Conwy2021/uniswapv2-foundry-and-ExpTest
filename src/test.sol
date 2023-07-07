//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Box is ERC721 {
    uint256 public Num;

    constructor(uint256 _num) ERC721("ALENT","AT2"){
        Num = _num;
    }
    function addNum(uint256 _num) public {
        Num += _num;
    }
}