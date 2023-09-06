
## 编译
```
scrab build 
```
## 部署
```
# 合约声明
starkli declare --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json target/dev/target/dev/helloERC20.starknet_artifacts.json 

# 合约部署
starkli deploy --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json  0x00eb1c90c377d7aafcdf7287cc4096376dbb182adf75b6ee7b01837a852d33d7  u256:1000000000000
```