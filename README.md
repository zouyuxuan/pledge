
## 编译
```
scrab build 
```
## 部署
```
# 合约声明
starkli declare --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json target/dev/helloERC20_pledge.sierra.json

# 合约部署
starkli deploy --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json  0x048d5da3df0f008ec0364b669db1bfb72720b715527999d6d802dd1e356e30eb  0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc u256:1000000000000
```

address 0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc
## 合约调用
```

export STARKNET_RPC="https://starknet-goerli.infura.io/v3/b3f456b556554dd0859813861561874a"


starkli call 0x02a9b35fcda5cc64dab71a08eb8b4c8ad744cf35916cc58163db115ec3ee9d87 get_total_supply


starkli invoke 0x02a9b35fcda5cc64dab71a08eb8b4c8ad744cf35916cc58163db115ec3ee9d87  add_white_list 0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc u256:1000  --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json 

0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc



starkli invoke 0x02a9b35fcda5cc64dab71a08eb8b4c8ad744cf35916cc58163db115ec3ee9d87 claim --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json 

starkli invoke 0x02a9b35fcda5cc64dab71a08eb8b4c8ad744cf35916cc58163db115ec3ee9d87 pledge_token u256:100 10 --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json 



starkli call 0x02a9b35fcda5cc64dab71a08eb8b4c8ad744cf35916cc58163db115ec3ee9d87 get_token_by_address 0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc


starkli call 0x02a9b35fcda5cc64dab71a08eb8b4c8ad744cf35916cc58163db115ec3ee9d87 get_pledge_account_by_address 0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc



starkli call 0x019a677b11a73f23d20eac1a4c4f6b9944a788f56f2a3d752912f15763cd3a1c pledge_token 100

// 提取
starkli invoke 0x02a9b35fcda5cc64dab71a08eb8b4c8ad744cf35916cc58163db115ec3ee9d87 withdrew 100 --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json 

```




