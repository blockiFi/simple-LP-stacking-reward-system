// this is a sample lp token 
// it mimics the simple behaviour of an LP token
// to add liquidity it simple takes Eth and mints 10X the lp token
// meaning for every 1 eth deposited you get 10 lp tokens


// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract LPtoken is ERC20{
     
     constructor () ERC20 ( "lptoken", "lp") {
         
     }
     function addliquidity(uint256 amount) public payable {
         require(msg.value >= amount ,"insuficient funds");
         _mint(msg.sender , amount*10);
         
     }
     function removeLiquidity(uint256 amount) public {
         require(amount > 0 );
        //  transferFrom(msg.sender , address(this) , amount);
         _burn(msg.sender , amount);
         payable(msg.sender).transfer(amount/10);
         
     }
}
interface ILPtoken {
 function addliquidity(uint256 amount) external payable;
 function removeLiquidity(uint256 amount) external;
 
}
