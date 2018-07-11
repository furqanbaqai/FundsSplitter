pragma solidity ^0.4.24;


/**
 * @title Parent contract for Making contract Ownable.
 */
contract Ownable{

    address public owner;

    /**
     * Modifier for checking if the procedure is called
     * by owner 
     */
    modifier ownerOnly{
        require(msg.sender == owner, "[ER01] Invalid owner address");
        _;
    }

     /**
     * Procedure no longer depends on any arguments.
     */ 
    constructor() public {
        owner = msg.sender;
    }

}