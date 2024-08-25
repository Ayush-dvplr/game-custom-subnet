// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;
import "./ERC20.sol";


contract Exploration {
    address public owner;
    uint public explorationFee = 100; // Fee to explore (e.g., 10 tokens)

    ERC20 erc20;
    
    event ExplorationAttempted(address indexed player, bool success, uint reward);
    
    constructor() {
        erc20 = new ERC20("Ayush","AYU");
        erc20.mintTokens(msg.sender, 1000); 
        owner = msg.sender;
    }
    
    // Player pays a fee to explore. Random chance of success.
    function explore() external {
        require(erc20.balanceOf(msg.sender) >= explorationFee, "Insufficient balance for fees");
        erc20.burnTokens(msg.sender, explorationFee);
        
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 100;
        bool success = randomNumber > 50;  // 50% chance of successful exploration
        
        if (success) {
            uint reward = explorationFee * 2; // Successful exploration doubles the stake
            erc20.mintTokens(msg.sender, reward);
            emit ExplorationAttempted(msg.sender, true, reward);
        } else {
            emit ExplorationAttempted(msg.sender, false, 0);
        }
    }

    function balanceOf() external view returns (uint){
        return erc20.balanceOf(msg.sender);
    }
}
