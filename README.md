
## 编译
```
scrab build 
```
## 部署
```
# 合约声明
starkli declare --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json target/dev/helloERC20_pledge.sierra.json

# 合约部署
starkli deploy --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json  0x0297ea517ade1658378f4723798069883169ac125078b09ed257b9c8d46ca25c  0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc u256:1000000000000
```

address 0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc
## 合约调用
```
starkli invoke 0x048e72d69b880a378b42848bf22777cc646d9d0349d39bece6a340570b4c712e  add_white_list 0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc u256:1000  --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json 

0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc

starkli call 0x048e72d69b880a378b42848bf22777cc646d9d0349d39bece6a340570b4c712e get_total_supply

starkli invoke 0x048e72d69b880a378b42848bf22777cc646d9d0349d39bece6a340570b4c712e claim --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json 

starkli call 0x048e72d69b880a378b42848bf22777cc646d9d0349d39bece6a340570b4c712e get_token

starkli call 0x019a677b11a73f23d20eac1a4c4f6b9944a788f56f2a3d752912f15763cd3a1c pledge_token 100
```



