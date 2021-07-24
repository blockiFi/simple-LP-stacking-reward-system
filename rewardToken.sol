
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
//this contract mimic an lp reward contract
//where users earn Rtoken for stacking the lp token 
//we have assumed a 2000% RPY

contract RewardToken is ERC20{
     ERC20 lpToken;
     struct stacking{
         uint256 amount;
         address account;
         uint256 startTime;
         uint256 unclaimedReward;
         address strategist;
         
     }
     
    mapping(address => stacking) public  lpStackings;
     modifier authorized(address account , address user){
         require(user == account || lpStackings[account].strategist == user);
         _;
     }
     constructor (address lpaddress) ERC20( "Rtoken", "Rtoken") {
         lpToken = ERC20(lpaddress);
         
     }
     function availableRewards(address account)  public view returns(uint256){
         if(lpStackings[account].amount == 0) return 0;
         uint256 timeSpendInHR = ( block.timestamp - lpStackings[account].startTime ) / 1 hours;
         uint256 yearlyreturns =lpStackings[account].amount * 20;
         return  yearlyreturns * timeSpendInHR / 8760;
     }
     function harvestReward(address account) private{
         uint256 rewards  = availableRewards(account);
         if(rewards > 0){
            stacking storage accountStacking =  lpStackings[account] ; 
            accountStacking.unclaimedReward += rewards;
            accountStacking.startTime = block.timestamp;
         }
     }
     function stackLptoken(address account , uint256 amount) public  {
         
         lpToken.transferFrom(msg.sender , address(this) , amount);
          stacking storage accountStacking =  lpStackings[account] ;
         harvestReward(account);
         accountStacking.amount += amount;
         accountStacking.startTime = block.timestamp;
         
     }
     function withdrawRewards(address account ) public authorized(account, msg.sender) {
          harvestReward(account);
          stacking storage accountStacking =  lpStackings[account] ;
          _mint(account , accountStacking.unclaimedReward);
          accountStacking.unclaimedReward = 0;
          
         
     }
     function removeStackedLP(address account )  public authorized( account ,msg.sender) {
         harvestReward(account);
          stacking storage accountStacking =  lpStackings[account] ;
          
         if(accountStacking.unclaimedReward > 0) _mint(account , accountStacking.unclaimedReward);
         
         if(accountStacking.amount > 0) lpToken.transfer(accountr , accountStacking.amount);
         
     }
    
}

