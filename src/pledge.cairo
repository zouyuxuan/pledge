use starknet::ContractAddress;
#[derive(Copy, Drop, Serde, starknet::Store)]
    struct PledgeInfo {
        block_time: u64,
        pledge_amount: u256,
        pledge_time: u64,
    }

#[starknet::interface]
trait PLEDGE<TContractState> {
    fn get_total_supply(self:@TContractState)->u256;
    fn add_white_list(ref self: TContractState, address: ContractAddress, mount: u256) -> bool;
    fn mint(ref self: TContractState) -> bool;
    fn pledge_token(ref self: TContractState, address: ContractAddress, amount: u256, pledge_time: u64) -> bool;
    fn get_token(self:@TContractState,address:ContractAddress)->u256;
    fn get_pledge_account(self:@TContractState,address:ContractAddress)->PledgeInfo;

    fn withdrew(ref self: TContractState,address:ContractAddress,amount:u256)->bool;
    fn get_total_pledge(self:@TContractState)->u256;
// fn get_pledge_rate(self:@TContractState)->felt252
}
#[starknet::contract]
mod pledge {
    use super::PledgeInfo;
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use starknet::get_block_timestamp;

    

    #[storage]
    struct Storage {
        _owner: ContractAddress,
        total_supply: u256,
        total_pledge:u256,
        white_list: LegacyMap::<ContractAddress, u256>,
        token_account:LegacyMap::<ContractAddress,u256>,
        pledge_account: LegacyMap::<ContractAddress, PledgeInfo>,
    }
    
    #[constructor]
    fn constructor(ref self: ContractState, amount: u256) {
        self.total_supply.write(amount);
        let owner = get_caller_address();
        self._owner.write(owner)
    }

    #[external(v0)]
    impl token_pledge of super::PLEDGE<ContractState> {
        fn get_total_supply(self:@ContractState)->u256{
            return self.total_supply.read();
        }
        fn add_white_list(ref self: ContractState, address: ContractAddress, mount: u256) -> bool {
            if (self._owner.read() == get_caller_address()) {
                self.white_list.write(address, mount);
                return true;
            }
            return false;
        }
        fn mint(ref self: ContractState) -> bool {
            let caller = get_caller_address();
            let amount = self.white_list.read(caller);
            if amount > 0 {
                self.total_supply.write(self.total_supply.read() + amount);
                self.token_account.write(caller,amount);
            }
            return true;
        }
        fn pledge_token(
            ref self: ContractState, address: ContractAddress, amount: u256, pledge_time: u64
        ) -> bool {
            let token_account = self.token_account.read(address);
            if token_account>0&&token_account >amount{
                self.token_account.write(address,token_account - amount);
                let pledge_info  = PledgeInfo{block_time:get_block_timestamp(),pledge_amount:amount,pledge_time:pledge_time};
                self.pledge_account.write(address,pledge_info);
                self.total_pledge.write(amount);
                return true;
            }
            return false;
        }
        fn get_token(self:@ContractState,address :ContractAddress)->u256{
            return self.token_account.read(address);
            
        }
        fn get_pledge_account(self:@ContractState,address:ContractAddress)->PledgeInfo{
           return  self.pledge_account.read(address);
        }
        fn withdrew(ref self: ContractState,address:ContractAddress, amount:u256)->bool{
           let mut pledge_info :PledgeInfo =  self.pledge_account.read(address);
           let block_time:u64 = get_block_timestamp();
                if pledge_info.pledge_time < block_time - pledge_info.block_time&&amount <pledge_info.pledge_amount{
                    self.token_account.write(address,self.token_account.read(address)+(pledge_info.pledge_amount-amount));
                    pledge_info.pledge_amount -= amount;
                    self.pledge_account.write(address,pledge_info);
                    self.total_pledge.write(self.total_pledge.read()-amount);

                    return true;
                }
                return false;
        }
        fn get_total_pledge(self:@ContractState)->u256{
            return self.total_pledge.read();
        }
    }
}
