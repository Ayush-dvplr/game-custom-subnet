# Creating EVM subnet with Ava Labs

- Created my own (custom) Subnet using the Avalanche-Cli.

## Steps to Follow

- avalanche subnet create ayush (chain ID : 10322) (Token Symbol : AYU)
- avalanche subnet deploy ayush
- Importing the account & Copying the private key in the metamask.
- Adding the network through RPC URL and chain ID
- Interacting with the game using the REMIX IDE

![App Screenshot](https://res.cloudinary.com/dsprifizw/image/upload/v1723483742/subnet-config.png)

![App Screenshot](https://res.cloudinary.com/dsprifizw/image/upload/v1723483936/metamask-balance.png)

## Objective

The DiceDuel contract is an ERC20-based game where players can bet tokens on a virtual dice roll. Players roll a dice against the contract, and depending on the outcome, they either win double their bet or lose their tokens. The contract also includes functionality for the owner to mint and burn tokens, ensuring the game's integrity and managing the in-game economy.

## Code by Code Explanation.

```Solidity

function randomDiceRoll(address source, uint256 seed) private view returns (uint256) {
        return (uint256(keccak256(abi.encodePacked(source, seed, block.timestamp, block.difficulty))) % 6) + 1;
    }

```

This code is implemented in my game a random number range from 1-6.

## Complete Code

```Solidity


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DiceDuel is ERC20 {
    address public owner;

    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);
    event DiceRolled(address indexed player, uint256 playerRoll, uint256 contractRoll, bool win);

    constructor() ERC20("DiceDuelToken", "DDT") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit Minted(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
        emit Burned(from, amount);
    }

    function rollDice(uint256 betAmount) public {
        require(betAmount > 0, "Bet amount must be greater than 0");
        require(balanceOf(msg.sender) >= betAmount, "Insufficient token balance");

        // Transfer bet amount to the contract
        _transfer(msg.sender, address(this), betAmount);

        // Player roll
        uint256 playerRoll = randomDiceRoll(msg.sender, block.timestamp);

        // Contract roll
        uint256 contractRoll = randomDiceRoll(address(this), block.number);

        bool playerWins = playerRoll > contractRoll;

        if (playerWins) {
            // Player wins, mint and transfer double the bet amount
            uint256 rewardAmount = betAmount * 2;
            _mint(msg.sender, rewardAmount);
        } else {
            // Player loses, burn the bet amount
            _burn(address(this), betAmount);
        }

        emit DiceRolled(msg.sender, playerRoll, contractRoll, playerWins);
    }

    function randomDiceRoll(address source, uint256 seed) private view returns (uint256) {
        return (uint256(keccak256(abi.encodePacked(source, seed, block.timestamp, block.difficulty))) % 6) + 1;
    }
}

```
##Author 

- Ayush sah[@linkedin](https://www.linkedin.com/in/ayushsah404/)


## License

This project is licensed under the MIT License - see the LICENSE.md file for details
