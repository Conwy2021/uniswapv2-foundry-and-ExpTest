// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
//import "./interface.sol";


contract EXP is Test{

    function setUp() public {
        vm.createSelectFork("mainnet");
      
    }

    address add = address(0x0);
    function testEXP() public{
    uint256 balance17=add.balance;
    emit log_named_decimal_uint("before  add balance ", balance17, 18);
    vm.deal(add,1 ether);
    uint256 balance20=add.balance;
    emit log_named_decimal_uint("after  add balance ", balance20, 18);
    }

}