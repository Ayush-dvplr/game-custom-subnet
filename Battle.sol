// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;
import "./ERC20.sol";

contract Battle  {
    uint public battleCount;
    event BattleStarted(uint indexed battleId, address indexed player1, address indexed player2, uint stake);
    event BattleWon(uint indexed battleId, address indexed winner, uint reward);

    ERC20 erc20;


    struct BattleInfo {
        address player1;
        address player2;
        uint stake;
        bool battleConcluded;
        address winner;
    }

    mapping(uint => BattleInfo) public battles;

    constructor() {
        erc20 = new ERC20("Ayush","AYU"); //
    }

    function mintToken(uint _amount) external{
        erc20.mintTokens(msg.sender,_amount);
    }

    function balance() external view returns(uint) {
       return erc20.balanceOf(msg.sender);
    }



    // Start a new battle between two players
    function startBattle(address _opponent, uint _stake) external {
        require(erc20.balanceOf(msg.sender) >= _stake, "Insufficient balance to stake");
        require(erc20.balanceOf(_opponent) >= _stake, "Opponent has insufficient balance");

        battleCount++;
        BattleInfo storage newBattle = battles[battleCount];

        newBattle.player1 = msg.sender;
        newBattle.player2 = _opponent;
        newBattle.stake = _stake;

        erc20.burnTokens(msg.sender, _stake);
        erc20.burnTokens(_opponent, _stake);

        emit BattleStarted(battleCount, msg.sender, _opponent, _stake);


    }

    // Conclude the battle (for example, using random dice rolls)
    function concludeBattle(uint _battleId) external {
        BattleInfo storage battle = battles[_battleId];
        require(!battle.battleConcluded, "Battle already concluded");

        // A simple random determination of the winner (this can be replaced with more sophisticated logic)
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 2;

        if (randomNumber == 0) {
            battle.winner = battle.player1;
        } else {
            battle.winner = battle.player2;
        }

        uint reward = battle.stake * 2; // Winner takes all
        erc20.mintTokens(battle.winner, reward);
        battle.battleConcluded = true;

        emit BattleWon(_battleId, battle.winner, reward);
    }
}
