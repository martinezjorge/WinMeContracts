// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@solmate/tokens/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WinMeToken is ERC20, Ownable {
    constructor() ERC20("Test", "TT", 18) Ownable(msg.sender) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}