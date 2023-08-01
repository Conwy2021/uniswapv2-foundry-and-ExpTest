# UniswapV2 Foundry

This repository contains the core and periphery smart contracts for the Uniswap V2 Protocol.

## Test

```
forge test --match-path ./test/UniswapV2.t.sol -vv
```

foundry 测试代币脚本
使用前 需要自己下载下 依赖库<br>
forge install --no-commit foundry-rs/forge-std <br>
forge install --no-commit OpenZeppelin/openzeppelin-contracts<br>
测试erc20 pair时 先执行
function testLog() public {
        emit log_named_bytes32("factory code hash", factory.INIT_CODE_PAIR_HASH());//先更新下lib 库里的pair hash
    }
<br>
执行命令时 //forge test --match-path ./test/bunnTest.sol --match-test testExploit  -vvv    windows里要注意 path 这里的路径是 /    (\会报错找到不到文件)