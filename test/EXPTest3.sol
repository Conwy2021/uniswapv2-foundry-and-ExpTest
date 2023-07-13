// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
//import "./interface.sol";
// 执行命令 forge test --match-path ./test/EXPTest2.sol -vvv
interface Investor  {
    function earn(address usr, address pol, uint256 str, uint256 amt, uint256 bor, bytes calldata dat)
        external
        
        returns (uint256);
}

interface ICamelotPair{

        function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint16 _token0FeePercent, uint16 _token1FeePercent);
}

contract EXP is Test{
    
    Investor vest  = Investor(0x8accf43Dd31DfCd4919cc7d65912A475BfA60369);
     ICamelotPair pairU_ETH  = ICamelotPair(0x84652bb2539513BAf36e225c930Fdd8eaa63CE27);
     ICamelotPair pairETH_unshETH  = ICamelotPair(0x29fC01f04032c76cA40f353c7dF685f4444c15eD);
    function setUp() public {
        vm.createSelectFork("arbitrum",110043452);
        vm.label(address(0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8), "USDC");
        vm.label(address(0xf3721d8A2c051643e06BF2646762522FA66100dA), "OracleTWAP");
        vm.label(address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1), "WETH");
        vm.label(address(0x0Ae38f7E10A43B5b2fB064B42a2f4514cbA909ef), "unshETH");
        vm.label(address(0x29fC01f04032c76cA40f353c7dF685f4444c15eD), "pair_WETH_USDC");
    }
        
    function testEXP() public{
    console2.log("test start");
    //weth_USDC pair 0x84652bb2539513baf36e225c930fdd8eaa63ce27
  
    // (bool success, bytes memory data)=address(0x84652bb2539513BAf36e225c930Fdd8eaa63CE27).call(abi.encodeWithSignature("getReserves()"));
    // console2.log("success",success);
    // console2.logBytes(data);
    // emit log_named_decimal_uint("success", rev0, 18);
    // emit log_named_decimal_uint("data", rev1, 18);

    //weth_unshETH pair 0x29fc01f04032c76ca40f353c7df685f4444c15ed
   
//     bytes memory data38 = abi.encodePacked(bytes4(0x0902f1ac));
//    // bytes memory name=new bytes(0x0902f1ac); EvmError: MemoryLimitOOG 这里会报错 Reason: EvmError: OutOfGas
//     (bool success2, bytes memory data2)=address(0x29fC01f04032c76cA40f353c7dF685f4444c15eD).call(data38);
//     console2.log("success",success2);
//     console2.logBytes(data2);
//   (returnAmount,) = abi.decode(returnData, (uint256, uint256)); // 解析返回值
      console2.log("weth_USDC before");
    (uint256 resa0,uint256 resa1, ,)= pairU_ETH.getReserves();
    emit log_named_decimal_uint("pairU_ETH ETH res0", resa0, 18);//ETH
    emit log_named_decimal_uint("pairU_ETH USDC res1", resa1, 6);//USDC
     console2.log("weth_unshETH before");
    (uint256 resa2,uint256 resa3, ,)= pairETH_unshETH.getReserves();
    emit log_named_decimal_uint("pairETH_unshETH unshETH res0", resa2, 18);//unshETH
    emit log_named_decimal_uint("pairETH_unshETH ETH res1", resa3, 18);//ETH

    bytes memory byteA = new bytes(0x00000000000000000000000000000000000000000000000000000000000001f4);
    uint256 a=vest.earn(0xE9544Ee39821F72c4fc87A5588522230e340aa54,0x0032F5E1520a66C6E572e96A11fBF54aea26f9bE,41,0,400000000000,byteA);
    console.log("a",a);
    
    (uint256 res0,uint256 res1, ,)= pairU_ETH.getReserves();
    emit log_named_decimal_uint("pairU_ETH ETH res0", res0, 18);//ETH
    emit log_named_decimal_uint("pairU_ETH USDC res1", res1, 6);//USDC
    (uint256 res2,uint256 res3, ,)= pairETH_unshETH.getReserves();
    emit log_named_decimal_uint("pairETH_unshETH unshETH res0", res2, 18);//unshETH
    emit log_named_decimal_uint("pairETH_unshETH ETH res1", res3, 18);//ETH


    }

}