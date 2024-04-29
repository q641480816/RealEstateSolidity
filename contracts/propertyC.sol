// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PROPERTYC is ERC20, Ownable {
    constructor(
        uint256 initialSupply,
        address initialRecipient
    ) ERC20("PROPERTYC", "PPRTC") Ownable() {
        uint256 totalSupply = initialSupply * (10 ** uint256(decimals()));
        address mintRecipient = initialRecipient == address(0)
            ? msg.sender
            : initialRecipient;
        _mint(mintRecipient, totalSupply);
    }

    function decimals() public pure override returns (uint8) {
        return 3;
    }
}
