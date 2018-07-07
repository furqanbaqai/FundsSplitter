pragma solidity ^0.4.23;

/**
 * @title Contract for keeping ledger of credit.
 * Credit will be divided into two and shall be assigned
 * to beneficiary 1 and beneficiary 2
 * Revision# 04: Incorporating Review comments by Rob.
 * Stretch Goals: After you addressed the small hints, refactor the contract so it can 
 * handle many splits from many people at the same time. Additionally, make it so each 
 * sender can name any two receivers. This means bob and carol are not special. You have 
 * to think about everyone.        
 **/
contract FundsSplitter {    

    struct Transaction{
        address sender;
        address receiver;        
        uint balance;               
    }
    bool public paused;
    address public owner;
    mapping(bytes32 => Transaction) public splitTransactions;
        
    
    event LogSplit(address indexed from, address receiver1, address receiver2, uint amount); /*Commit#4: Refactoring*/ 
    event LogWithdrawl(address indexed who, uint amount, uint balance); /*Commit#3: Index withdrawal */    
    event LogPause(address sender);
    event LogUnPause(address sender);
    
    /**
     * Modifier for checking if the procedure is called
     * by owner 
     */
    modifier ownerOnly{
        require(msg.sender == owner, "[ER01] Invalid owner address");
        _;
    }

    /**
     * Modifier to validate if contract is not paused
     */
    modifier whenNotPaused(){
        require(!paused, "[ER05] Contract is paused");
        _;
    }

    /**
     * Modifier to validate if the contract is paused
     */
    modifier whenPaused(){
        require(paused, "[ER06] Contract is not paused");
        _;
    }

    /**
     * Procedure no longer depends on any arguments.
     */ 
    constructor() public {
        owner = msg.sender;
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
        bytes32 key1 = keccak256(msg.sender,receiver1);
        bytes32 key2 = keccak256(msg.sender,receiver2);
        splitTransactions[key1] = Transaction(msg.sender,receiver1, splitTransactions[key1].balance+amount);
        splitTransactions[key2] = Transaction(msg.sender,receiver2,splitTransactions[key2].balance +(msg.value - amount));        
        emit LogSplit(msg.sender, receiver1,receiver2, msg.value);
        return true;
    }

    /**
     * Procedure for withdrawing debited amount to the 
     * specific owner
     * @param amount Funds to withdraw
     * @param sender Address of the transaction initiator
     */
    function withdrawFunds(uint amount, address sender) whenNotPaused public{
        // this function will withdraw whole funds associated with each
        // address and transfer the amount to the resp
        require(amount > 0); // Funds can not be <= 0
        bytes32 key = keccak256(sender,msg.sender);
        require(splitTransactions[key].receiver == msg.sender,"[ER03] Invalid address");
        require(splitTransactions[key].balance >= amount,"[ER03] Not enough Funds");
        splitTransactions[key].balance -= amount;
        splitTransactions[key].receiver.transfer(amount);        
    }
    

    /**
     * Procedure to pause the contract
     */
    function pause() ownerOnly whenNotPaused public{
        paused = true;
        emit LogPause(msg.sender);
    }

    /**
     * Procedure to unpause the contract
     */
    function unpause() ownerOnly whenPaused public{
        paused = false;
        emit LogUnPause(msg.sender);
    }
    
}