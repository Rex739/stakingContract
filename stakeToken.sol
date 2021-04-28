// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;
// import both Ex and Dapp Token

import "./ExToken.sol";
import "./DappToken.sol";

contract TokenFarm {
   string public name = "Dapp Token Farm";
   ExToken public exToken;
   DappToken public dappToken;
   address public owner;
   
   
   mapping(address => uint) public stakingBalance;
   mapping(address => bool) public hasStaked;
   mapping(address => bool) public isStaking;
   address[] public staker;
   
   constructor(ExToken _Extoken, DappToken _Dapptoken) public {
       exToken = _Extoken;
       dappToken = _Dapptoken;
       owner = msg.sender;
   }
   modifier onlyOwner{
       require(owner == msg.sender, "You are not the owner");
       _;
   }
   
   function balanceOfStaker() public view returns(uint256){
       return exToken.balanceOf(msg.sender);
   }
   function stakeToken(uint256 _amount) public payable{
       _amount = exToken.balanceOf(msg.sender);
       require(_amount > 0,"You must have tokens to stake");
       
       exToken.transferFrom(msg.sender, address(this), _amount);
       
       stakingBalance[msg.sender] += _amount;
       
       if(!hasStaked[msg.sender]) {
           staker.push(msg.sender);
       }
       hasStaked[msg.sender] = !false;
       isStaking[msg.sender] = !false;
       
   }
   
    function unstakeToken() public {
        require(isStaking[msg.sender] = !false);
        uint balance = stakingBalance[msg.sender];
        exToken.transfer(msg.sender, balance);
        isStaking[msg.sender] == !true;
    }
    
    function stakeAmount() public view returns(uint) {
        return stakingBalance[msg.sender];
    }
    
    function issueToken() public onlyOwner{
        for(uint i=0; i < staker.length; i++){
            address recipient = staker[i];
            uint balance = stakingBalance[recipient];
            if(isStaking[recipient] == !false){
                dappToken.transfer(recipient, balance);
            }
        }
    }
   
   
}
