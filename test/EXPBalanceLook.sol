// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
//import "./interface.sol";

// 执行命令 forge test --match-path ./test/EXPTest2.sol -vvv
contract EXP is Test{

    function setUp() public {
        vm.createSelectFork("base",1934081);
      
    }

    address add = address(0xccFa0530B9d52f970d1A2dAEa670ce58E4176389);
    function testEXP() public{
    uint256 balance17=add.balance;
    emit log_named_decimal_uint("before  add balance ", balance17, 18);
    // vm.deal(add,1 ether);
    // uint256 balance20=add.balance;
    // emit log_named_decimal_uint("after  add balance ", balance20, 18);
    console.log("111");
    }

}