// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PROPERTYB is ERC20, Ownable {
    constructor() ERC20("PROPERTYB", "PPRTB") Ownable() {
        uint256 totalSupply = 980 * (10 ** uint256(decimals()));

        _mint(msg.sender, totalSupply);
    }

    function decimals() public pure override returns (uint8) {
        return 3;
    }
}