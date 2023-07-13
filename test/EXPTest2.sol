// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
//import "./interface.sol";
// 执行命令 forge test --match-path ./test/EXPTest2.sol -vvv
contract IGuard  {
    struct Config {
        uint256 valueMin;
        uint256 accessRate;
        uint256 leverageMin;
        uint256 leverageMax;
        uint256 leverageRate;
        //mapping(address => bool) poolBlacklist;
    }
     mapping(address => Config) public strategies;
}

contract EXP is Test{
    
    IGuard guard  = IGuard(0xdD30b56dFfD6063505dDAf9E758Cb7d133A56DDA);
    function setUp() public {
        vm.createSelectFork("arbitrum",110043452);
        
      
    }
    address add = (0x9E058177A854336D962D5aE576E9A46cFd8374D7);
    function testEXP() public{
     uint256 a;
     uint256 b;
     uint256 c;
     uint256 d;
     uint256 e;
     (a,b,c,d,e) = guard.strategies(add);//结构体 可以之际接收参数
    console2.log(a);
    console2.log(b);
    console2.log(c);
    console2.log(d);
    console2.log(e);
    console2.log("owner3 -> pair");
    emit log_named_decimal_uint("owner2 token", 2222222, 18);
    }

}