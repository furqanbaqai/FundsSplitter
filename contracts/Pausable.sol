pragma solidity ^0.4.24;

import "./Ownable.sol";

/**
 * @title Contract blueprint for encapstulating Owners information
 */
contract Pausable is Ownable{

    bool public paused;

    event LogPause(address initiator);
    event LogUnPause(address initiator);
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