// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PROPERTYC is ERC20, Ownable {
    constructor() ERC20("PROPERTYC", "PPRTC") Ownable() {
        uint256 totalSupply = 1756 * (10 ** uint256(decimals()));

        _mint(msg.sender, totalSupply);
    }

    function decimals() public pure override returns (uint8) {
        return 3;
    }
}