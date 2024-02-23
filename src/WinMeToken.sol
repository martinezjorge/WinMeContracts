// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@solmate/tokens/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("Test", "TT", 18) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}