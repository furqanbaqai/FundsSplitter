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
    address alice; /* Owner of the contract */
    address bob; /* Beneficiary 1 */
    address carol; /* Beneficiary 2*/
    bool public paused;
    
    uint public bobBalance;
    uint public carolBalance;
    
    event LogSplit(address indexed from, address receiver1, address receiver2, uint amount); /*Commit#4: Refactoring*/ 
    event LogWithdrawl(address indexed who, uint amount, uint balance); /*Commit#3: Index withdrawal */    
    event LogPause(address sender);
    event LogUnPause(address sender);
    
    /**
     * Modifier for checking if the procedure is called
     * by owner 
     */
    modifier ownerOnly{
        require(msg.sender == alice, "[ER01] Invalid owner address");
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
     * Adding bob and carol add so that contract is
     * bounded to the addresses set during deployement time.
     * @param bobAdd Bob's Address
     * @param carolAdd Carol's Address
     */
    constructor(address bobAdd, address carolAdd) public{
        // Leting Alice be the owner of the contract
        alice = msg.sender;
        bob = bobAdd;
        carol = carolAdd;
    }
       
    /**
     * Fucntion for dividing credits into two and debiting 
     * carol and bob's accounts by dividing the credit into two
     * @return success Incase funds are split sucessfully
     **/
    function splitFunds() public payable ownerOnly whenNotPaused returns(bool succcess)  {
        require(bob != address(0) ,"[ER02] Invalid address");
        require(carol != address(0),"[ER02] Invalid address");
        uint amount = msg.value / 2;        
        bobBalance = bobBalance + amount;
        carolBalance = msg.value - amount;        
        emit LogSplit(msg.sender, bob,carol, msg.value);
        return true;
    }

    /**
     * Procedure for withdrawing debited amount to the 
     * specific owner
     * @param funds Funds to withdraw
     */
    function withdrawFunds(uint amount) whenNotPaused public{
        // this function will withdraw whole funds associated with each
        // address and transfer the amount to the resp
        require(amount > 0); // Funds can not be <= 0
        if(msg.sender == bob){
            // initiate transaction from bob
            require (amount <= bobBalance, "[ER03] Not enough funds");
            bobBalance -= amount;            
            msg.sender.transfer(amount);
            emit LogWithdrawl(msg.sender,amount,bobBalance);
        }else if(msg.sender == carol){
            // initiate transaction from carol            
            require (amount <= carolBalance, "[ER03] Not enough funds");
            bobBalance -= amount;            
            msg.sender.transfer(amount);
            emit LogWithdrawl(msg.sender,amount, carolBalance);
        }else{
            revert("[ER04] Invlaid address");
        }        
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