// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/test/TestERC20.sol";
import "../src/test/WETH9.sol";
import "../src/UniswapV2Factory.sol";
import "../src/UniswapV2Router02.sol";
import "../src/libraries/Math.sol";
import "../src/interfaces/IUniswapV2Pair.sol";
import {Token} from "../src/ELF.sol";

contract UniswapV2Test is Test {
    WETH9 public weth;

    
    Token public token;
    UniswapV2Factory public factory;
    UniswapV2Router02 public router;

    address public owner = address(0x1);
    address public feeTo = address(0x2);
    address public owner2 = address(0x5);
    address public owner3 = address(0x6);
    address public owner4 = address(0x7);

    address public marketingAddress = address(0x3);
    address public teamAddress = address(0x4);
    address public service = address(0x8);
    uint256[] public  inviters;// 数组类型 放到外面声明使用

    function setUp() public {
        
        
       
        
        vm.startPrank(owner); //修改 msg.sender
        weth = new WETH9();
        vm.label(address(weth), "weth");
        factory = new UniswapV2Factory(owner);
        factory.setFeeTo(feeTo);
        router = new UniswapV2Router02(address(factory), address(weth));
        
        token = new Token("ETF","ETF",18,1000000000,address(router),owner,marketingAddress,teamAddress,service);
        vm.stopPrank();

        //默认label 是合约的名字
        vm.label(address(owner3), "owner3");
        vm.label(address(owner2), "owner2");
        vm.label(address(owner), "owner");
        vm.label(address(owner4), "owner4");
        vm.label(address(token), "token");

    }

    function testLog() public {
        emit log_named_bytes32("factory code hash", factory.INIT_CODE_PAIR_HASH());//先更新下lib 库里的pair hash
    }

    function testTransfer() external {
        console2.log("start testTransfer");
        address pair3 = factory.getPair(address(weth), address(token));
        
        //transfer test
        vm.prank(owner);
        token.transfer(owner2, 100000 ether);
        uint256 balance58 = token.balanceOf(owner);
        emit log_named_decimal_uint("owner  token", balance58, 18);
        uint256 balance60 = token.balanceOf(owner2);
        emit log_named_decimal_uint("owner2 token", balance60, 18);

        vm.prank(owner2);
        token.transfer(owner3, 100000 ether);
        uint256 balance65 = token.balanceOf(owner2);
        uint256 balance66 = token.balanceOf(owner3);
        emit log_named_decimal_uint("owner2 token", balance65, 18);
        emit log_named_decimal_uint("owner3 token", balance66, 18);
        addLiquidityETH(owner); //添加流动性

        uint256 balance71 = token.balanceOf(pair3);
        emit log_named_decimal_uint("pair before", balance71, 18);
        uint256 balance84 = token.balanceOf(address(0xdead));
        emit log_named_decimal_uint("0xdead before", balance84, 18);
        console2.log("owner3 -> pair");
        vm.prank(owner3);
        token.transfer(pair3, 100 ether);
        uint256 balance72 = token.balanceOf(owner3);
        uint256 balance73 = token.balanceOf(pair3);
        emit log_named_decimal_uint("pair after", balance73, 18);
        emit log_named_decimal_uint("owner3 after", balance72, 18);
        uint256 balance90 = token.balanceOf(token.marketingWalletAddress());
        uint256 balance91 = token.balanceOf(token.teamWalletAddress());
        uint256 balance92 = token.balanceOf(address(0xdead));
        uint256 balance94 = token.balanceOf(address(token));
        emit log_named_decimal_uint("marketingWallet", balance90, 18);
        emit log_named_decimal_uint("teamWallet", balance91, 18);
        emit log_named_decimal_uint("0xdead after", balance92, 18);
        emit log_named_decimal_uint("token after", balance94, 18);
        
        vm.prank(pair3);
    }

    function testLiquidityOwner() public {
        addLiquidityETH(owner);
        removeLiquidityETH(owner);
    }

    function testLiquidityNormal() public {
        vm.startPrank(owner);
        token.transfer(owner2, 100 ether);
     
         vm.stopPrank();
      
        addLiquidityETH(owner2);
        removeLiquidityETH(owner2);
        
    }

    function testSwapSell() public {
        addLiquidityETH(owner);
        //  切换一次角色
        vm.prank(owner);
        token.transfer(owner2, 100 ether);
        
        uint256 balance93 = token.balanceOf(owner2);
        emit log_named_decimal_uint("TOKEN IN owner2 before swap", balance93, 18);
        address[] memory pathCStoUSDT = new address[](2);
        pathCStoUSDT[0] = address(token);
        pathCStoUSDT[1] = address(weth);
        console2.log("sell token start");
        address pair3 = factory.getPair(address(weth), address(token));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        vm.startPrank(owner2); // 伪装秘籍
        token.approve(address(router), 100 ether);
        
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            100 ether,
            0,
            pathCStoUSDT,
            owner2,
            block.timestamp + 1000
        );
        vm.stopPrank();
        uint256 balance114 = token.balanceOf(owner2);
        emit log_named_decimal_uint("TOKEN IN owner2 after swap", balance114, 18);
        uint256 balance127 = token.balanceOf(token.marketingWalletAddress());
        emit log_named_decimal_uint("TOKEN IN owner2 after swap marketingWallet", balance127, 18);
        uint256 balance129 = token.balanceOf(token.teamWalletAddress());
        emit log_named_decimal_uint("TOKEN IN owner2 after swap teamWallet", balance129, 18);
         uint256 balance131 = token.balanceOf(address(0xdead));
        emit log_named_decimal_uint("TOKEN IN owner2 after swap 0xdead", balance131, 18);
        
        (uint256 token0, uint256 token1, ) = pair.getReserves();
        emit log_named_decimal_uint("Reserves token0", token0, 18);
        emit log_named_decimal_uint("Reserves token1", token1, 18);
    }

    function testSwapBuy() public {
        addLiquidityETH(owner);
        //  加钱秘籍
        vm.deal(owner2,100 ether);
        uint256 balance93 = owner2.balance;
        emit log_named_decimal_uint(
            "eth IN owner2 before swap",
            balance93,
            18
        );
        address[] memory pathUSDTtoCS = new address[](2);
        pathUSDTtoCS[0] = address(weth);
        pathUSDTtoCS[1] = address(token);
        console2.log("swap buy start");
        address pair3 = factory.getPair(address(weth), address(token));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        vm.startPrank(owner2); // 伪装秘籍
        

        router.swapExactETHForTokensSupportingFeeOnTransferTokens{value:100 ether}(
            0,
            pathUSDTtoCS,
            owner2,
            block.timestamp + 1000
        );
        vm.stopPrank();
        uint256 balance114 = owner2.balance;
        emit log_named_decimal_uint(
            "weth IN owner2 after swap",
            balance114,
            18
        );
        (uint256 token0, uint256 token1, ) = pair.getReserves();
        emit log_named_decimal_uint("Reserves token0", token0, 18);
        emit log_named_decimal_uint("Reserves token1", token1, 18);
        uint256 balance151 = token.balanceOf(owner2);
        emit log_named_decimal_uint("token in owner2", balance151, 18);
        uint256 balance195 = token.balanceOf(address(token));
        emit log_named_decimal_uint("token in token", balance195, 18);
    }

    function testskim() public {
        addLiquidityETH(owner);
        address pair3 = factory.getPair(address(weth), address(token));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        vm.prank(owner);
        token.transfer(pair3, 100 ether);
        uint256 balance162 = token.balanceOf(pair3);
        emit log_named_decimal_uint("before  token in pair ", balance162, 18);
        uint256 token0; uint256 token1;
        ( token0,  token1, ) = pair.getReserves();
        emit log_named_decimal_uint("token0", token0, 18);
        emit log_named_decimal_uint("token1", token1, 18);
        pair.skim(pair3);
        uint256 balance174 = token.balanceOf(pair3);
        emit log_named_decimal_uint("after skim token in pair ", balance174, 18);
        ( token0,  token1, ) = pair.getReserves();
        emit log_named_decimal_uint("token0", token0, 18);
        emit log_named_decimal_uint("token1", token1, 18);

    }

    function removeLiquidityETH(address _user) internal {
        address pair3 = factory.getPair(address(weth), address(token));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        uint256 LPbalance = pair.balanceOf(_user);
        vm.startPrank(_user);
        pair.approve(address(router), LPbalance / 2);

        uint256 balance94 = pair.balanceOf(_user);
        emit log_named_decimal_uint("removeLiquidity before", balance94, 18);

        router.removeLiquidityETHSupportingFeeOnTransferTokens(
            address(token),
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

    function addLiquidityETH(address _user) internal {
        console2.log("addLiquidityETH start");
        address pair3 = factory.getPair(address(weth), address(token));
        IUniswapV2Pair pair = IUniswapV2Pair(pair3);
        // console2.log(cs3);
        // assertEq(pair2, pair3);
       // assertEq(pair3, 0x02D6f5411E796000bCB0569a136b40bE41219772);
        vm.deal(_user,100 ether);
        vm.startPrank(_user);
       
        token.approve(address(router), 100 ether);
        router.addLiquidityETH{value:100 ether}(
            address(token),
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
        (r0,r1)=pair.token0()==address(weth)?(r0,r1):(r1,r0);
        emit log_named_decimal_uint("WETH IN POOL", r0, 18);
        emit log_named_decimal_uint("TOKEN IN POOL", r1, 18);
    }


    
}
