// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";

contract WinMeTokenEscrow is Ownable {
    uint256 public number;
    using SafeERC20 for IERC20Permit;
    mapping(address => bool) public approvedTokens;
    mapping(address => uint256) public winnings;

    event TokenApproved(address indexed token, bool indexed approvedStatus);

    constructor() Ownable(msg.sender) {}

    /// @notice Allows users to pay game entry fee
    function payGameEntranceFee(
        
    ) external {

    }

    /// @notice Lets players claim ERC20 tokens (doesn't require pre-approval)
    function claimTokenWithPermit() external {}

    /* Admin Functions */

    /// @notice Allows the contract owner to toggle whether an address is a valid payment token for escrow
    /// @param token The address of the token to add or remove
    function togglePaymentToken(address token) external onlyOwner {
        approvedTokens[token] = !approvedTokens[token];
        emit TokenApproved(token, approvedTokens[token]);
    }

    // @notice Emergency function to withdraw stuck tokens
    function withdrawStuckTokens(
        address token,
        uint256 tokenAmount
    ) external onlyOwner {}
}
