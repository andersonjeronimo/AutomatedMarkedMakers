// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract LiquidityPool is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    IERC20 public token0;
    IERC20 public token1;
    uint public reserve0; //balance token 0
    uint public reserve1; //balance token 1

    constructor() ERC20("Liquidity Pool Token", "LPT") Ownable(msg.sender) {}

    function _sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }            
        } else if(y != 0){
            z = 1;
        }
    }

    function _min(uint256 x, uint256 y) returns (uint256 r) {
        r = (x <= y) ? x : y;
    }

    function _update(uint _reserve0, uint _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;        
    }

    function addTokenPair(address _token0, address _token1) external onlyOwner {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function addLiquidity(
        uint _amount0,
        uint _amount1
    ) external nonReentrant returns (uint shares) {        
        if (reserve0 > 0 || reserve1 > 0) {
            //passa aqui caso seja primeiro depósito
            require(reserve0 * _amount1 == reserve1 * _amount0, "Error: x / y != dX / dY"); //x / y == dX / dY
        }
        //token pair owner must approve first!
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        uint totalSupply = totalSupply();
        if (totalSupply == 0) {
            //passa aqui caso seja primeiro depósito
            shares = _sqrt(_amount0 * _amount1);            
        } else {
            shares = _min(
                (_amount0 * totalSupply) / reserve0,
                (_amount1 * totalSupply) / reserve1
            );
        }
        require(shares > 0, "Shares = 0");
        _mint(msg.sender, shares);
        _update(reserve0 + _amount0, reserve1 + _amount1);
    }
    
    
}