// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "./InterestRateModel.sol";
contract CounterTest is Test {
    InterestRateModel public interestRateModel;
 
    function setUp() public {
        IInterestRateModel.Config memory c =  IInterestRateModel.Config(800000000000000000,900000000000000000,500000000000000000,367011,951293759513,63419583968,396372400,69444444444444,0,0);
        interestRateModel = new InterestRateModel(c);
        
    }

    function test() public {
        IInterestRateModel.Config memory c =  IInterestRateModel.Config(800000000000000000,900000000000000000,500000000000000000,367011,951293759513,63419583968,396372400,69444444444444,0,0);
        uint256 _totalDeposits=100000;
        uint256 _totalBorrowAmount=1000000000000000000;
        uint256 _interestRateTimestamp=1682622215;
        uint256 _blockTimestamp=1682622239;
        (uint256 rcomp,,)=interestRateModel.calculateCompoundInterestRate(c,_totalDeposits,_totalBorrowAmount,_interestRateTimestamp,_blockTimestamp);
        console.log("rcomp",rcomp);
        emit log_named_decimal_uint("rcomp",rcomp, 18);
    }

    
}
