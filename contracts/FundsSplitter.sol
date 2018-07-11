pragma solidity ^0.4.24;

import "./Pausable.sol";

/**
 * @title Contract for keeping ledger of credit.
 * Credit will be divided into two and shall be assigned
 * to beneficiary 1 and beneficiary 2
 * Revision# 08: Incorporating Review comments by Rob.
 **/
contract FundsSplitter is Pausable {    
      
    mapping(address => uint) public balances;        
    
    event LogSplit(address indexed from, address receiver1, address receiver2, uint amount); /*Commit#4: Refactoring*/ 
    event LogWithdrawl(address indexed who, uint amount); /*Commit#3: Index withdrawal */        
    


    /**
     * Procedure no longer depends on any arguments.
     */ 
    constructor() public {       
    }
       
    /**
     * Refactored! Proecure will take receiver address and does 
     * not depends on the owner.
     **/
    function splitFunds(address receiver1, address receiver2) public payable whenNotPaused returns(bool success)  {                
        require(receiver1 != address(0), "[ER02] Invalid address");
        require(receiver2 != address(0), "[ER02] Invalid address");
        require(receiver1 != receiver2, "[ER02] Invalid address");
        require(msg.value > 0, "[ER04] Invalid Values");
        uint amount = msg.value / 2;                
        balances[receiver1] += amount;
        balances[receiver2] += amount;
        if(msg.value % 2 == 1) balances[msg.sender] += 1;
        emit LogSplit(msg.sender, receiver1,receiver2, msg.value);
        return true;
    }

    /**
     * Procedure for withdrawing debited amount to the 
     * specific owner
     * @param amount Funds to withdraw
     */
    function withdrawFunds(uint amount) whenNotPaused public returns(bool success){
        require(amount > 0); // Funds can not be <= 0
        require(balances[msg.sender] > 0, "[ER03] Invalid address");
        require(balances[msg.sender] >= amount, "[ER04] Not enough Funds");
        balances[msg.sender] -= amount;
        emit LogWithdrawl(msg.sender, amount);
        msg.sender.transfer(amount);
        return true;
    }
    

    
}