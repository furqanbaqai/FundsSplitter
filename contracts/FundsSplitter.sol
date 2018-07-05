pragma solidity ^0.4.23;

/**
 * @title Contract for keeping ledger of credit.
 * Credit will be divided into two and shall be assigned
 * to beneficiary 1 and beneficiary 2
 **/
contract FundsSplitter {
    address alice; /* Owner of the contract */
    address bob; /* Beneficiary 1 */
    address carol; /* Beneficiary 2*/
    bool public paused = false;
    
    uint bobBalance;
    uint carolBalance;
    
    event LogSplitFunds(address indexed who, uint ttlCr, uint bobBalance, uint carolBalance); /*Commit#2: Changing to CapCase*/ 
    event LogWithdrawl(address indexed who, uint fundsWith, uint balance); /*Commit#3: Index withdrawal */    
    event LogPause();
    event LogUnPause();
    
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
        require((bob != address(0)) && (carol != address(0)), "[ER02] Invalid address");
        uint amount = msg.value / 2;        
        bobBalance = bobBalance + amount;
        carolBalance = msg.value - amount;        
        emit LogSplitFunds(msg.sender, msg.value, bobBalance, carolBalance);
        return true;
    }

    /**
     * Procedure for withdrawing debited amount to the 
     * specific owner
     * @param funds Funds to withdraw
     */
    function withdrawFunds(uint funds) whenNotPaused public{
        // this function will withdraw whole funds associated with each
        // address and transfer the amount to the resp
        require(funds > 0); // Funds can not be <= 0
        if(msg.sender == bob){
            // initiate transaction from bob
            require (funds <= bobBalance, "[ER03] Not enough funds");
            bobBalance -= funds;
            emit LogWithdrawl(msg.sender,funds,bobBalance);
            msg.sender.transfer(funds);
        }else if(msg.sender == carol){
            // initiate transaction from carol            
            require (funds <= carolBalance, "[ER03] Not enough funds");
            bobBalance -= funds;
            emit LogWithdrawl(msg.sender,funds, carolBalance);
            msg.sender.transfer(funds);
        }else{
            revert("[ER04] Invlaid address");
        }        
    }
    
    /**
     * Function for fetching balance of an account 
     * @return balance Balance of the owner
     **/
    function getBalance() view public returns(uint balance) {
        if(msg.sender == bob){
            return bobBalance;
        }else if (msg.sender == carol){
            return carolBalance;
        }else revert("[ER04] Invalid address provided");
        
    }

    /**
     * Procedure to pause the contract
     */
    function pause() ownerOnly whenNotPaused public{
        paused = true;
        emit LogPause();
    }

    /**
     * Procedure to unpause the contract
     */
    function unpause() ownerOnly whenPaused public{
        paused = false;
        emit LogUnPause();
    }
    
}