// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract WinMeTokenClaim {
    uint256 public number;

    mapping(address => bool) public approvedTokens;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}