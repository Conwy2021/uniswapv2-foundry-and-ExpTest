// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/test/TestERC20.sol";
import "../src/test/WETH9.sol";
import "../src/UniswapV2Factory.sol";
import "../src/UniswapV2Router02.sol";
import "../src/libraries/Math.sol";
import "../src/interfaces/IUniswapV2Pair.sol";
import {CS2} from "../src/NfDAO.sol";

contract UniswapV2Test is Test {
    WETH9 public weth;

    TestERC20 public usdt;
    CS2 public cs;
    UniswapV2Factory public factory;
    UniswapV2Router02 public router;

    address public owner = address(0x1);
    address public feeTo = address(0x2);
    address public firstLP = address(0x3);
    address public secLP = address(0x4);

    address public owner2 = address(0x5);
    address public owner3 = address(0x6);
    address public owner4 = address(0x7);
    uint256[] public  inviters;// 数组类型 放到外面声明使用

    function setUp() public {
        vm.startPrank(owner); //修改 msg.sender

        weth = new WETH9();
        usdt = new TestERC20("USDT", "USDT");
        console2.log("USDT", address(usdt));
        factory = new UniswapV2Factory(owner);
        factory.setFeeTo(feeTo);
        router = new UniswapV2Router02(address(factory), address(weth));
        cs = new CS2(address(usdt), address(router));
        console2.log("CS", address(cs));
        usdt.mint(owner, 100 ether);
        usdt.approve(address(router), 100 ether);
        cs.approve(address(router), 100 ether);
        
    
      
        vm.stopPrank();
        vm.label(address(usdt), "usdt"); //默认label 是合约的名字
        vm.label(address(owner3), "owner3");
        vm.label(address(owner2), "owner2");
        vm.label(address(owner), "owner");
        vm.label(address(owner4), "owner4");

         
    }

    function testLog() public {
        emit log_named_bytes32("factory code hash", factory.INIT_CODE_PAIR_HASH());//先更新下lib 库里的pair hash
    }

    function testTransfer() external {
        console2.log("start");
        address pair3 = factory.getPair(address(usdt), address(cs));
        
        //transfer test
        vm.prank(owner);
        cs.transfer(owner2, 100000 ether);
        uint256 balance58 = cs.balanceOf(owner);
        emit log_named_decimal_uint("owner  cs", balance58, 18);
        uint256 balance60 = cs.balanceOf(owner2);
        emit log_named_decimal_uint("owner2 cs", balance60, 18);

        vm.prank(owner2);
        cs.transfer(owner3, 100000 ether);
        uint256 balance65 = cs.balanceOf(owner2);
        uint256 balance66 = cs.balanceOf(owner3);
        emit log_named_decimal_uint("owner2 cs", balance65, 18);
        emit log_named_decimal_uint("owner3 cs", balance66, 18);
        addLiquidity(owner); //添加流动性

        uint256 balance71 = cs.balanceOf(pair3);
        emit log_named_decimal_uint("pair before", balance71, 18);
        uint256 balance84 = cs.balanceOf(address(0xdead));
        emit log_named_decimal_uint("0xdead before", balance84, 18);
        console2.log("owner3 -> pair");
        vm.prank(owner3);
        cs.transfer(pair3, 100 ether);
        uint256 balance72 = cs.balanceOf(owner3);
        uint256 balance73 = cs.balanceOf(pair3);
        emit log_named_decimal_uint("pair after", balance73, 18);
        emit log_named_decimal_uint("owner3 after", balance72, 18);
        uint256 balance90 = cs.balanceOf(cs._fundAddr());
        uint256 balance91 = cs.balanceOf(cs._marketAddr());
        uint256 balance92 = cs.balanceOf(address(0xdead));
        emit log_named_decimal_uint("_fundAddr", balance90, 18);
        emit log_named_decimal_uint("_marketAddr", balance91, 18);
        emit log_named_decimal_uint("0xdead after", balance92, 18);
        
        vm.prank(pair3);
    }

    function testLiquidityOwner() public {
        addLiquidity(owner);
        removeLiquidity(owner);
    }

    function testLiquidityNormal() public {
        vm.startPrank(owner);
        cs.transfer(owner2, 100 ether);
        usdt.mint(owner2, 100 ether);
         vm.stopPrank();
       // addLiquidity(); 
        addLiquidity(owner2);
        removeLiquidity(owner2);
        
    }

    function testSwapSell() public {
        addLiquidity(owner);
        //  加钱秘籍
        vm.prank(owner);
        cs.transfer(owner2, 100 ether);
        
        uint256 balance93 = cs.balanceOf(owner2);
        emit log_named_decimal_uint("CS IN owner2 before swap", balance93, 18);
        address[] memory pathCStoUSDT = new address[](2);
        pathCStoUSDT[0] = address(cs);
        pathCStoUSDT[1] = address(usdt);
        console2.log("sell token start");
        address pair3 = factory.getPair(address(usdt), address(cs));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        vm.startPrank(owner2); // 伪装秘籍
        cs.approve(address(router), 100 ether);
        
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            100 ether,
            0,
            pathCStoUSDT,
            owner2,
            block.timestamp + 1000
        );
        vm.stopPrank();
        uint256 balance114 = cs.balanceOf(owner2);
        emit log_named_decimal_uint("CS IN owner2 after swap", balance114, 18);
        uint256 balance127 = cs.balanceOf(cs._marketAddr());
        emit log_named_decimal_uint("CS IN owner2 after swap _marketAddr", balance127, 18);
        uint256 balance129 = cs.balanceOf(cs._fundAddr());
        emit log_named_decimal_uint("CS IN owner2 after swap _fundAddr", balance129, 18);
         uint256 balance131 = cs.balanceOf(address(0xdead));
        emit log_named_decimal_uint("CS IN owner2 after swap 0xdead", balance131, 18);
        
        (uint256 token0, uint256 token1, ) = pair.getReserves();
        emit log_named_decimal_uint("Reserves token0", token0, 18);
        emit log_named_decimal_uint("Reserves token1", token1, 18);
    }

    function testSwapBuy() public {
        addLiquidity(owner);
        //  加钱秘籍
        vm.prank(owner);
        usdt.mint(owner2, 100 ether);
        uint256 balance93 = usdt.balanceOf(owner2);
        emit log_named_decimal_uint(
            "usdt IN owner2 before swap",
            balance93,
            18
        );
        address[] memory pathUSDTtoCS = new address[](2);
        pathUSDTtoCS[0] = address(usdt);
        pathUSDTtoCS[1] = address(cs);
        console2.log("swap buy start");
        address pair3 = factory.getPair(address(usdt), address(cs));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        vm.startPrank(owner2); // 伪装秘籍
        usdt.approve(address(router), 100 ether);

        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            100 ether,
            0,
            pathUSDTtoCS,
            owner2,
            block.timestamp + 1000
        );
        vm.stopPrank();
        uint256 balance114 = usdt.balanceOf(owner2);
        emit log_named_decimal_uint(
            "usdt IN owner2 after swap",
            balance114,
            18
        );
        (uint256 token0, uint256 token1, ) = pair.getReserves();
        emit log_named_decimal_uint("Reserves token0", token0, 18);
        emit log_named_decimal_uint("Reserves token1", token1, 18);
        uint256 balance151 = cs.balanceOf(owner2);
        emit log_named_decimal_uint("cs in owner2", balance151, 18);
    }

    function testskim() public {
        addLiquidity(owner);
        address pair3 = factory.getPair(address(usdt), address(cs));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        vm.prank(owner);
        cs.transfer(pair3, 100 ether);
        uint256 balance162 = cs.balanceOf(pair3);
        emit log_named_decimal_uint("before  cs in pair ", balance162, 18);
        uint256 token0; uint256 token1;
        ( token0,  token1, ) = pair.getReserves();
        emit log_named_decimal_uint("token0", token0, 18);
        emit log_named_decimal_uint("token1", token1, 18);
        pair.skim(pair3);
        uint256 balance174 = cs.balanceOf(pair3);
        emit log_named_decimal_uint("after skim cs in pair ", balance174, 18);
        ( token0,  token1, ) = pair.getReserves();
        emit log_named_decimal_uint("token0", token0, 18);
        emit log_named_decimal_uint("token1", token1, 18);

    }

    function removeLiquidity(address _user) internal {
        address pair3 = factory.getPair(address(usdt), address(cs));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        uint256 LPbalance = pair.balanceOf(_user);
        vm.startPrank(_user);
        pair.approve(address(router), LPbalance / 2);

        uint256 balance94 = pair.balanceOf(_user);
        emit log_named_decimal_uint("removeLiquidity before", balance94, 18);

        router.removeLiquidity(
            address(cs),
            address(usdt),
            LPbalance / 2,
            0,
            0,
            _user,
            block.timestamp + 1000
        );
        vm.stopPrank();
        uint256 balance107 = pair.balanceOf(_user);
        emit log_named_decimal_uint("removeLiquidity after", balance107, 18);
    }

    function addLiquidity(address _user) internal {
        console2.log("addLiquidity start");
        address pair3 = factory.getPair(address(usdt), address(cs));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        // console2.log(cs3);
        // assertEq(pair2, pair3);
        assertEq(pair3, 0x02D6f5411E796000bCB0569a136b40bE41219772);
        vm.startPrank(_user);
        usdt.approve(address(router), 100 ether);
        cs.approve(address(router), 100 ether);
        router.addLiquidity(
            address(cs),
            address(usdt),
            100 ether,
            100 ether,
            0,
            0,
            _user,
            block.timestamp + 1000
        );
        vm.stopPrank();

        uint256 Lp = pair.balanceOf(_user);
        // console2.log(Lp);
        assertEq(Lp, 100 ether - 1000 wei);
        assertEq(pair.totalSupply(), 100 ether);
        (uint256 r0, uint256 r1, ) = pair.getReserves();
        //console2.log(pair.token0(),pair.token1());
        emit log_named_decimal_uint("USDT IN POOL", r0, 18);
        emit log_named_decimal_uint("CS IN POOL", r1, 18);
    }


    function addLiquidity2(address _user) internal {// 添加代币顺序不同
        address pair3 = factory.getPair(address(usdt), address(cs));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        // console2.log(cs3);
        // assertEq(pair2, pair3);
        assertEq(pair3, 0x02D6f5411E796000bCB0569a136b40bE41219772);
        vm.startPrank(_user);
        usdt.approve(address(router), 100 ether);
        cs.approve(address(router), 100 ether);
        router.addLiquidity(
            address(usdt),
            address(cs),
            100 ether,
            100 ether,
            0,
            0,
            _user,
            block.timestamp + 1000
        );
        vm.stopPrank();

        uint256 Lp = pair.balanceOf(_user);
        // console2.log(Lp);
        assertEq(Lp, 100 ether - 1000 wei);
        assertEq(pair.totalSupply(), 100 ether);
        (uint256 r0, uint256 r1, ) = pair.getReserves();
        //console2.log(pair.token0(),pair.token1());
        emit log_named_decimal_uint("USDT IN POOL", r0, 18);
        emit log_named_decimal_uint("CS IN POOL", r1, 18);
    }
}
