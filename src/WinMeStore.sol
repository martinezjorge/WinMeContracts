// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/// @notice You should always use SafeERC20 to transfer ERC20 tokens
contract WinMeStore is Ownable {
    using SafeERC20 for IERC20;

    IERC20 winMeToken;
    address treasury;
    uint256 networkCurrencyPrice;

    struct TokenRegistry {
        uint256 decimals;
        bool active;
    }

    mapping(address => TokenRegistry) paymentTokens;

    constructor(address _winMeTokenAddress, address _treasuryAddress) Ownable(msg.sender) {
        winMeToken = IERC20(_winMeTokenAddress);
        treasury = _treasuryAddress;
    }

    /// @notice a function to purchase WinMeToken with ETH
    /// @notice watch out for reentrancy attacks
    /// @notice on arbitrum this will be ARB, on optimism OP, on Polygon MATIC
    function purchaseWinMeTokenWithNetworkCurrency() external payable {
        require(msg.value == networkCurrencyPrice);
    }

    /// @notice should allow users to purchase WinMe token with USDT
    function purchaseWinMeTokenWithERC20(address _tokenAddress) external {

    }

    function purchaseWinMeNftWithNetworkCurrency() external payable {}

    function purchaseWinMeNftWithERC20() external {}

    // ADMIN FUNCTIONS
    function setTreasuryAddress(address _newTreasuryAddress) external onlyOwner {
        treasury = _newTreasuryAddress;
    }

    function setNetworkCurrencyPrice(uint256 _newPrice) external onlyOwner {
        networkCurrencyPrice = _newPrice;
    }
}
