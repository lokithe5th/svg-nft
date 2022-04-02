// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @custom:security-contact lourenslinde@gmail.com
contract Blossoms is ERC20 {
    constructor() ERC20("Blossoms", "BLSMS") {
        _mint(msg.sender, 10000000 * 10 ** decimals());
    }
}