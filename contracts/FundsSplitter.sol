pragma solidity ^0.4.23;

/**
 * @title Contract for keeping ledger of credit.
 * Credit will be divided into two and shall be assigned
 * to beneficiary 1 and beneficiary 2
 **/
contract FundsSplitter {
    address public alice; /* Owner of the contract */
    address public bob; /* Beneficiary 1 */
    address public carol; /* Beneficiary 2*/
    
    uint public bobBalance;
    uint public carolBalance;
    
    event LogAccountDebit(address indexed who, uint ttlCr, uint amtCr); /*Commit#2: Changing to CapCase*/ 
    event LogReset(address indexed who, address bobAdd, address carolAdd); /*Commit#2: Changing to CapCase*/ 

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
     **/
    function splitFunds() public payable returns(bool succcess){
        require((msg.sender == alice) && (bob != address(0)) && (carol != address(0)));
        uint amount = msg.value / 2;
        emit LogAccountDebit(msg.sender, msg.value, amount);
        bobBalance = bobBalance + amount;
        carolBalance = carolBalance + amount;
        bob.send(amount);
        carol.transfer(amount);
        return true;
    }
    
    /**
     * Function for fetching balance of an account 
     **/
    function getBalance(address add) view public returns(uint balance) {
        if(bob == add){
            return bobBalance;
        }else if (carol == add){
            return carolBalance;
        }else revert();
        
    }
    
}