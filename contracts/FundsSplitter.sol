pragma solidity ^0.4.23;

/**
 * Contract for keeping ledger of credit.
 * Credit will be divided into two and shall be assigned
 * to beneficiary 1 and beneficiary 2
 **/
contract FundsSplitter {
    address alice; /* Owner of the contract */
    address bob; /* Beneficiary 1 */
    address carol; /* Beneficiary 2*/
    
    uint public bobBalance;
    uint public carolBalance;
    
    event logAccountDebit(address indexed who, uint ttlCr, uint amtCr);
    event logReset(address indexed who, address bobAdd, address carolAdd);

    
    constructor() public{
        // Leting Alice be the owner of the contract
        alice = msg.sender;
    }
    
    /**
     * Function for seting bob's address 
     **/
    function setBobAdd(address bobAdd) public{
        assert(bob == address(0) && alice == msg.sender);
        bob = bobAdd;
    }
    
    /**
     * Function for seting carol's address
     **/
    function setCarolAdd(address carolAdd) public{
        assert(carol == address(0) && alice == msg.sender);
        carol = carolAdd;
    }
    
    
    /**
     * Fucntion for dividing credits into two and debiting 
     * carol and bob's accounts by dividing the credit into two
     **/
    function debit(uint credit) public{
        require((msg.sender == alice) && (bob != address(0)) && (carol != address(0)));
        uint amount = credit / 2;
        emit logAccountDebit(msg.sender, credit, amount);
        bobBalance = bobBalance + amount;
        carolBalance = carolBalance + amount;
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

    function reset() public{
        require(msg.sender == alice);
        emit logReset(msg.sender,bob,carol);
        bob = address(0);
        carol = address(0);
        bobBalance = 0;
        carolBalance = 0;
    }
    
}