// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PROPERTYA is ERC20, Ownable {
    constructor() ERC20("PROPERTYA", "PPRTA") Ownable() {
        uint256 totalSupply = 1253 * (10 ** uint256(decimals()));

        _mint(msg.sender, totalSupply);
    }

    function decimals() public pure override returns (uint8) {
        return 3;
    }
}