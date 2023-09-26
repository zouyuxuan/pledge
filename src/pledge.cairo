use starknet::ContractAddress;
use array::ArrayTrait;
#[derive(Copy, Drop, Serde, starknet::Store)]
    struct PledgeInfo {
        // startknet block timestamp 
        block_time: u64,
        // pledge amount 
        pledge_amount: u256,
        // pledge time 
        pledge_time: u64,
        on_sell:bool,
        sell_num:u256,
        profit:u256,
        withdraw_profit:u256,
    }

#[starknet::interface]
trait PLEDGE<TContractState> {
    // get total supply
    fn get_total_supply(self:@TContractState)->u256;
    // add white list
    fn add_white_list(ref self: TContractState, address: ContractAddress, amount: u256) -> bool;
    // claim
    fn claim(ref self: TContractState) -> u256;
    fn set_rate(ref self: TContractState,rate:u8)->bool;
    // check token number by address
    fn get_token_by_address(self:@TContractState,address: ContractAddress)->u256;

    // pledge token 
    fn pledge_token(ref self: TContractState, amount: u256, pledge_time: u64) -> bool;
    // get pledge account by address
    fn get_pledge_account_by_address(self:@TContractState,address:ContractAddress)->PledgeInfo;
    // withdrew
    fn withdrew(ref self: TContractState,amount:u256)->bool;
    fn withdrew_profit(ref self: TContractState,address:ContractAddress)->u256;
    fn sell_starking(ref self: TContractState,sell_number:u256)->felt252;
    fn check_onsell_starking(self:@TContractState,sell_hash:felt252)->PledgeInfo;
    fn buy_starking(ref self: TContractState,sell_hash:felt252,sell_address:ContractAddress)->bool;
    fn transfer_starking(ref self: TContractState,to_address:ContractAddress)->bool;
    // get total pledge
    fn get_total_pledge(self:@TContractState)->u256;
    fn get_burn(self:@TContractState)->u256;

}
#[starknet::contract]
mod pledge {
    use super::PledgeInfo;
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use starknet::get_block_timestamp;
    use core::pedersen;
    use traits::Into;

    #[storage]
    struct Storage {
        _owner: ContractAddress,
        total_supply: u256,
        total_pledge:u256,
        burn_total: u256,
        pledge_rate: u8,
        white_list: LegacyMap::<ContractAddress, u256>,
        token_account:LegacyMap::<ContractAddress,u256>,
        pledge_account:LegacyMap::<ContractAddress,felt252>,
        pledge_account_info:LegacyMap::<felt252, PledgeInfo>,
    }
    
    #[constructor]
    fn constructor(ref self: ContractState, address:ContractAddress,amount: u256,rate:u8) {
        self.total_supply.write(amount);
        self._owner.write(address);
        self.pledge_rate.write(rate);
        self.token_account.write(address,amount);
    }

    #[external(v0)]
    impl token_pledge of super::PLEDGE<ContractState> {
        fn get_total_supply(self:@ContractState)->u256{
            return self.total_supply.read();
        }
        fn add_white_list(ref self: ContractState, address: ContractAddress, amount: u256) -> bool {
            if (self._owner.read() == get_caller_address()) {
                self.total_supply.write(self.total_supply.read() + amount);
                self.white_list.write(address, amount);
                return true;
            }
            return false;
        }
        fn claim(ref self: ContractState) -> u256 {
            let caller = get_caller_address();
            let amount = self.white_list.read(caller);

            assert(amount >0 ,'not token to claim...');
            
            self.token_account.write(caller,amount);
            
            self.white_list.write(caller,0);
            return amount;
        }
        fn set_rate(ref self: ContractState,rate:u8)->bool{
            self.pledge_rate.write(rate);
            return true;
        }
        fn pledge_token(
            ref self: ContractState,  amount: u256, pledge_time: u64
        ) -> bool {
            let address = get_caller_address();
            let token_account = self.token_account.read(address);

            assert(token_account >0 ,'pledge token failed');
            assert(token_account >=amount,'starking deyond');
            
            self.token_account.write(address,token_account - amount);
            let block_time =get_block_timestamp();
            let pledge_info  = PledgeInfo{block_time:block_time,pledge_amount:amount,pledge_time:pledge_time,on_sell:false,sell_num:0_u256,profit:0,withdraw_profit:0};
            let m:felt252 = block_time.into();
            let peldge_hash:felt252 = pedersen(m,address.into());
            self.pledge_account_info.write(peldge_hash,pledge_info);
            self.total_pledge.write(amount);
            return true;
           
        }
        fn get_token_by_address(self:@ContractState,address:ContractAddress)->u256{
            return self.token_account.read(address);
        }
        fn get_pledge_account_by_address (self:@ContractState,address:ContractAddress)->PledgeInfo{
           let pledge_hash:felt252 = self.pledge_account.read(address);
           return self.pledge_account_info.read(pledge_hash);
        }
        fn withdrew(ref self: ContractState, amount:u256)->bool{
            let address = get_caller_address();
            let  pledge_hash :felt252 =  self.pledge_account.read(address);
            let mut pledge_info:PledgeInfo = self.pledge_account_info.read(pledge_hash);
            assert(pledge_info.on_sell==true,'pledge on sell ,withdraw fail');
            let block_time:u64 = get_block_timestamp();

            assert(pledge_info.pledge_amount > amount,'withdraw beyond');
            assert(block_time - pledge_info.block_time > pledge_info.pledge_time ,'pledge time has not arrived' );
            // Calculate profit
            let profit:u256 = amount *self.pledge_rate.read().into()*pledge_info.pledge_time.into()/100;
            
            self.token_account.write(address,self.token_account.read(address)+(pledge_info.pledge_amount-amount));
            pledge_info.pledge_amount -= amount;
            pledge_info.profit = profit;

            

            self.pledge_account_info.write(pledge_hash,pledge_info);
            self.total_pledge.write(self.total_pledge.read()-amount);
            return true;
                
        }

         fn withdrew_profit(ref self: ContractState,address:ContractAddress)->u256{
            let (profit,) = self._calculate_profit(address);
            // spent from owner account
            self.token_account.write(self._owner.read(),self.token_account.read(self._owner.read()) - profit);
            let hash = self.pledge_account.read(address);
            let mut pledge_info = self.pledge_account_info.read(hash);

            return profit;
            
        }
        fn get_total_pledge(self:@ContractState)->u256{
            return self.total_pledge.read();
        }
        fn sell_starking(ref self: ContractState,sell_number:u256)->felt252{
            let address = get_caller_address();
            let pledge_hash:felt252 = self.pledge_account.read(address);
            let mut pledge_info:PledgeInfo = self.pledge_account_info.read(pledge_hash);
            assert(pledge_info.pledge_amount==0,'no pledge ');
            pledge_info.sell_num = sell_number;
            pledge_info.on_sell = true;
            self.pledge_account_info.write(pledge_hash,pledge_info);
            return pledge_hash;
        }
        fn check_onsell_starking(self:@ContractState,sell_hash:felt252)->PledgeInfo{
            return self.pledge_account_info.read(sell_hash);

        }
        fn buy_starking(ref self: ContractState,sell_hash:felt252,sell_address:ContractAddress)->bool{
            let address = get_caller_address();
            let mut  pledge_info :PledgeInfo = self.pledge_account_info.read(sell_hash);
            self.burn_total.write(2);
            let pledge_hash:felt252 = '';
            self.pledge_account.write(sell_address,pledge_hash);
            self.pledge_account.write(address,sell_hash);
            pledge_info.on_sell = false;
            pledge_info.sell_num = 0_u256;
            self.pledge_account_info.write(sell_hash,pledge_info);
            self.token_account.write(sell_address,pledge_info.sell_num - 2);
            return true;


        }
        fn transfer_starking(ref self: ContractState,to_address:ContractAddress)->bool{
            let address = get_caller_address();
            let from_hash = self.pledge_account.read(address);
            let to_hash = self.pledge_account.read(to_address);

            assert(from_hash =='','caller has not pledge ');
            assert(to_hash !='','to_address has pledge ');

            self.pledge_account.write(address,'');
            self.pledge_account.write(to_address,from_hash);
            return true;
        }
        // get burn total
        fn get_burn(self:@ContractState)->u256{
            return self.burn_total.read();
        }
    }
    #[generate_trait]
    impl ProfitImpl of ProfitFunctionsTrait{
        fn _calculate_profit(ref self: ContractState, address: ContractAddress)->(u256,){
            let hash = self.pledge_account.read(address);
            let  pledge_info = self.pledge_account_info.read(hash);
            let current_time = get_block_timestamp();
            let mut profit_time :u64 = 0;
            if current_time - pledge_info.block_time > pledge_info.pledge_time{
                profit_time = pledge_info.pledge_time
            }else{
                 profit_time = current_time - pledge_info.block_time
            }
            // Calculate profit
            let profit:u256 = pledge_info.pledge_amount *self.pledge_rate.read().into()*profit_time.into()/100;
            return (profit,);
        }
    }
}
