// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IAggregatorV3} from "src/interfaces/IAggregatorV3.sol";
import {IWinMeToken} from "src/interfaces/IWinMeToken.sol";
import "forge-std/console.sol";

interface IWinMeKarts {
    function mintNft(address _to) external;
}

/// @notice You should always use SafeERC20 to transfer ERC20 tokens
contract WinMeStore is Ownable {
    using SafeERC20 for IERC20;

    IWinMeToken winMeToken;
    IWinMeKarts winMeNft;
    IAggregatorV3 priceFeed;

    address payable treasury;
    uint256 networkCurrencyPrice;

    // 1 token = 2.00 usd, with 2 decimal places
    uint256 public winMeTokenPrice = 2E8;
    uint256 public winMeNftPrice = 10E8;

    struct TokenRegistry {
        uint256 decimals;
        bool active;
    }

    mapping(IERC20 => TokenRegistry) paymentTokens;

    event WinMeTokenPurchasedWithNetworkCurrency(
        uint256 indexed currencyUsdPrice,
        uint256 indexed currencyAmount,
        uint256 indexed winMeTokenReceived
    );

    event WinMeTokenPurchasedWithStableCoin(
        address indexed stableCoin,
        uint256 indexed stableCoinAmount,
        uint256 indexed winMeTokenReceived
    );

    event NftPurchasedWithWinMeToken(
        uint256 indexed winMeTokenAmount
    );

    constructor(
        address payable _treasuryAddress, 
        IWinMeToken _winMeTokenAddress,
        IWinMeKarts _winMeNft,
        IAggregatorV3 _aggregatorAddress
    ) Ownable(msg.sender) {
        winMeToken = _winMeTokenAddress;
        winMeNft = _winMeNft;
        priceFeed = _aggregatorAddress;
        treasury = _treasuryAddress;
    }

    // Chainlink Stuff
    /**
    * Returns the latest network currency price in USD
    */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }

    function winMeTokenAmount(uint256 currencyAmount) public returns (uint256) {
        //Sent amountETH, how many usd I have
        uint256 ethUsd = uint256(getChainlinkDataFeedLatestAnswer());       //with 8 decimal places
        uint256 amountUSD = currencyAmount * ethUsd / 10E18; //ETH = 18 decimal places
        uint256 amountToken = amountUSD / winMeTokenPrice * 10E18;  //8 decimal places from ETHUSD / 2 decimal places from token 
        emit WinMeTokenPurchasedWithNetworkCurrency(ethUsd, currencyAmount, amountToken);
        return amountToken;
    }

    /// @notice a function to purchase WinMeToken with ETH
    /// @notice watch out for reentrancy attacks
    function purchaseWinMeTokenWithNetworkCurrency() external payable {
        require(msg.value > 0, "Ether value greatar than zero required!");
        uint256 amountToken = winMeTokenAmount(msg.value);
        payable(treasury).transfer(msg.value);
        winMeToken.mint(msg.sender, amountToken);
    }

    /// @notice should allow users to purchase WinMe token
    function purchaseWinMeTokenWithStableCoin(IERC20 paymentToken, uint256 paymentAmount) external {
        TokenRegistry memory registry = paymentTokens[paymentToken];
        require(registry.active, "This payment token is not active");
        paymentToken.safeTransferFrom(msg.sender, address(treasury), paymentAmount);
        uint256 _winMeTokenAmount = paymentAmount * 1E8 * 1E18 / 1**registry.decimals / winMeTokenPrice;
        winMeToken.mint(msg.sender, _winMeTokenAmount);
        emit WinMeTokenPurchasedWithStableCoin(address(paymentToken), paymentAmount, _winMeTokenAmount);
    }

    function purchaseWinMeNftWithWinMeToken() external {
        winMeToken.transferFrom(msg.sender, treasury, 20E18);
        winMeNft.mintNft(msg.sender);
        emit NftPurchasedWithWinMeToken(20E18);
    }

    // ADMIN FUNCTIONS //

    function setTokenInRegistry(IERC20 token, uint256 decimals, bool approved) external onlyOwner {
        paymentTokens[token] = TokenRegistry(decimals, approved);
    }

    function setWinMeTokenPrice(uint256 _newWinMeTokenPrice) external onlyOwner {
        winMeTokenPrice = _newWinMeTokenPrice;
    }

    function setWinMeNftPrice(uint256 _newWinMeNftPrice) external onlyOwner {
        winMeNftPrice = _newWinMeNftPrice;
    }

    function setTreasuryAddress(address payable _newTreasuryAddress) external onlyOwner {
        treasury = _newTreasuryAddress;
    }

    function setNetworkCurrencyPrice(uint256 _newPrice) external onlyOwner {
        networkCurrencyPrice = _newPrice;
    }
}
