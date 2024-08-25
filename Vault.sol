// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
import "./ERC20.sol";

contract Vault {
    ERC20 token;
    uint public shares;
    address public _owner;

    uint public totalSupply;
    uint public totalShares;
    mapping(address => uint) public balanceOf;

    constructor() {
        token = new ERC20("Ayush","AYU");
        // _owner = msg.sender;
        // _tokenaddress = _token;
        totalSupply = token.totalSupply();
    }

   function transferFunc(address owner,address _recepient,uint _amount) internal{
    token.transferFunc(owner,_recepient,_amount);
   }

    function _mint(address _to, uint _shares) internal {
        totalShares += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint _shares) internal {
        totalShares -= _shares;
        balanceOf[_from] -= _shares;
    }

    // function deposit(uint _amount) external {
    //     /*
    //     a = amount
    //     B = balance of token before deposit
    //     T = total supply
    //     s = shares to mint

    //     (T + s) / T = (a + B) / B 

    //     s = aT / B
    //     */
    //     uint shares;
    //     if (totalSupply == 0) {
    //         shares = _amount;
    //     } else {
    //         shares = (_amount  * totalSupply) / token.balanceOf(msg.sender);
    //     }

    //     require(shares >0,"Shares is 0");

    //     _mint(msg.sender, shares);
    //    bool res =  token.transferFrom(msg.sender, address(this), _amount);
    //    require(res,"faild");
    // }



  
   function deposit(uint _amount) external {
        require(_amount > 0, "Amount must be greater than 0");

        uint256 tokenBalance = token.balanceOf(msg.sender);

        if (totalSupply == 0) {
            shares = _amount;
        } else {
            require(tokenBalance > 0, "Token balance must be greater than 0");
            shares = (_amount* totalSupply)/ tokenBalance;
        }

       _mint(msg.sender,shares);
       transferFunc(msg.sender,address(this),_amount);
    }

    function balance() external view returns(uint){
        return token.balanceOf(msg.sender);
    }

    function withdraw(uint _shares) external {
        /*
        a = amount
        B = balance of token before withdraw
        T = total supply
        s = shares to burn

        (T - s) / T = (B - a) / B 

        a = sB / T
        */
        // uint amount = (_shares * token.balanceOf(msg.sender)) / totalSupply;
        _burn(msg.sender, _shares);
        transferFunc(address(this), msg.sender, shares);
    }

    function getTotalSupply() external{
          totalSupply = token.totalSupply();
    }

  
}