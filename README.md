# UniswapV2 Foundry

This repository contains the core and periphery smart contracts for the Uniswap V2 Protocol.

## Test

```
forge test --match-path ./test/UniswapV2.t.sol -vv
```

foundry 测试代币脚本
使用前 需要自己下载下 依赖库
forge install --no-commit foundry-rs/forge-std
forge install --no-commit OpenZeppelin/openzeppelin-contracts