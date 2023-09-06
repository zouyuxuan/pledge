
## 编译
```
scrab build 
```
## 部署
```
# 合约声明
starkli declare --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json target/dev/helloERC20_pledge.sierra.json

# 合约部署
starkli deploy --keystore ~/.starknet_accounts/key.json --account ~/.starknet_accounts/starkli.json  0x01fde902a700a6b72f835e95eae7148195aa1bafb5bae31adb5daf96a4b60723  u256:1000000000000
```
## 合约调用
```
starkli call 0x019a677b11a73f23d20eac1a4c4f6b9944a788f56f2a3d752912f15763cd3a1c add_white_list 0x02B2e99c243a33a9DcaE5436233c6D26609D12a4d8405fa281B6a8Db3386823F u256:1000

starkli call 0x019a677b11a73f23d20eac1a4c4f6b9944a788f56f2a3d752912f15763cd3a1c get_total_supply

starkli call 0x019a677b11a73f23d20eac1a4c4f6b9944a788f56f2a3d752912f15763cd3a1c claim

starkli call 0x019a677b11a73f23d20eac1a4c4f6b9944a788f56f2a3d752912f15763cd3a1c get_token

starkli call 0x019a677b11a73f23d20eac1a4c4f6b9944a788f56f2a3d752912f15763cd3a1c pledge_token 100
```



