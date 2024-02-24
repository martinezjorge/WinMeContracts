// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WinMeTokenClaim is Ownable {
    uint256 public number;

    mapping(address => bool) public approvedTokens;

    event TokenApproved(address indexed token, bool indexed approvedStatus);

    constructor() Ownable(msg.sender) {}

    /// @notice Allows the contract owner to toggle whether an address is a valid payment token for escrow
    /// @param token The address of the token to add or remove
    function togglePaymentToken(address token) external onlyOwner {
        approvedTokens[token] = !approvedTokens[token];
        emit TokenApproved(token, approvedTokens[token]);
    }

}