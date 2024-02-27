// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @notice You should always use SafeERC20 to transfer ERC20 tokens
contract WinMeStore is Ownable {
    using SafeERC20 for IERC20;

    address usdcTokenAddress;
    address usdtTokenAddress;
    address openDollarTokenAddress;

    constructor() Ownable(msg.sender) {}

    /// @notice a function to purchase WinMeToken with ETH
    /// @notice watch out for reentrancy attacks
    /// @notice on arbitrum this will be ARB, on optimism OP, on Polygon MATIC
    function purchaseWithNetworkCurrency() external payable {}

    /// @notice should allow users to purchase WinMe token with USDT
    function purchaseWithUSDT() external {}

    /// @notice should allow users to purchase WinMe token with USDC
    function purchaseWithUSDC() external {}

    function purchaseWithOpenDollar() external {}

    /// @notice should allow the owner to transfer the eth out of the contract
    function retrieveNetworkCurrencyInContract() external onlyOwner {}

    /// setter functions for the stablecoins
    function setUSDCAddress(address _usdcAddress) external onlyOwner {}

    function setUSDTAddress(address _usdcAddress) external onlyOwner {}

    function setOpenDollarAddress(address _usdcAddress) external onlyOwner {}
}
