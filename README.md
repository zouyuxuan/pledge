
## 编译
```
scrab build 
```
## 部署
```
# 合约声明
starkli declare --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json target/dev/helloERC20_pledge.sierra.json

# 合约部署
starkli deploy --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json  0x06288817e91cf5ba8658e4e5e4a61fdd8d9195a885d15b59c2f4bd3ebc06c06d  0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc u256:10000
```

address 0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc
## 合约调用
```

export STARKNET_RPC="https://starknet-goerli.infura.io/v3/b3f456b556554dd0859813861561874a"


starkli call 0x007889f71086e6dfce3142d3d5db8961dce79cfaef07618a5bb1cf0a3a3ae576 get_total_supply


starkli invoke 0x007889f71086e6dfce3142d3d5db8961dce79cfaef07618a5bb1cf0a3a3ae576  add_white_list 0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc u256:1000  --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json 

# claim 
starkli invoke 0x007889f71086e6dfce3142d3d5db8961dce79cfaef07618a5bb1cf0a3a3ae576 claim --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json 

# get_token_by_address 
starkli call 0x007889f71086e6dfce3142d3d5db8961dce79cfaef07618a5bb1cf0a3a3ae576 get_token_by_address 0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc

# pledge_token 
starkli invoke 0x007889f71086e6dfce3142d3d5db8961dce79cfaef07618a5bb1cf0a3a3ae576 pledge_token u256:100 1 --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json 

# get_pledge_account_by_address 
starkli call 0x007889f71086e6dfce3142d3d5db8961dce79cfaef07618a5bb1cf0a3a3ae576 get_pledge_account_by_address 0xba30489493eaefa14bae7ad817be1218f291e4d0b2099fda64ae263ec360cc


# withdrew
starkli invoke 0x007889f71086e6dfce3142d3d5db8961dce79cfaef07618a5bb1cf0a3a3ae576 withdrew u256:10 --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json 

# get_total_pledge
starkli call 0x007889f71086e6dfce3142d3d5db8961dce79cfaef07618a5bb1cf0a3a3ae576 get_total_pledge

```




