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
