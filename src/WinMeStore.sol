// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IAggregatorV3} from "src/interfaces/IAggregatorV3.sol";
import {IWinMeToken} from "src/interfaces/IWinMeToken.sol";

/// @notice You should always use SafeERC20 to transfer ERC20 tokens
contract WinMeStore is Ownable {
    using SafeERC20 for IERC20;

    IWinMeToken winMeToken;
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

    constructor(
        address payable _treasuryAddress, 
        IWinMeToken _winMeTokenAddress, 
        IAggregatorV3 _aggregatorAddress
    ) Ownable(msg.sender) {
        winMeToken = _winMeTokenAddress;
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

    function winMeTokenAmount(uint256 amountETH) public view returns (uint256) {
        //Sent amountETH, how many usd I have
        uint256 ethUsd = uint256(getChainlinkDataFeedLatestAnswer());       //with 8 decimal places
        uint256 amountUSD = amountETH * ethUsd / 10E18; //ETH = 18 decimal places
        uint256 amountToken = amountUSD / winMeTokenPrice * 10E18;  //8 decimal places from ETHUSD / 2 decimal places from token 
        return amountToken;
    }

    // needs some love
    // function winMeNftEthPrice(uint256 amountETH) public view returns (uint256) {
    //     //Sent amountETH, how many usd I have
    //     uint256 ethUsd = uint256(getChainlinkDataFeedLatestAnswer());       //with 8 decimal places
    //     uint256 amountUSD = amountETH * ethUsd / 10**18; //ETH = 18 decimal places
    //     uint256 amountToken = amountUSD / winMeTokenPrice / 10**(8/2);  //8 decimal places from ETHUSD / 2 decimal places from token 
    //     return amountToken;
    // }

    /// @notice a function to purchase WinMeToken with ETH
    /// @notice watch out for reentrancy attacks
    /// @notice on arbitrum this will be ARB, on optimism OP, on Polygon MATIC
    function purchaseWinMeTokenWithNetworkCurrency() external payable {
        uint256 amountToken = winMeTokenAmount(msg.value);
        winMeToken.mint(msg.sender, amountToken);
    }

    // Needs some love
    function purchaseWinMeNftWithNetworkCurrency() external payable {
        // uint256 amountToken = tokenAmount(msg.value);
        // winMeNft.mint(msg.sender, amountToken);
    }

    /// @notice should allow users to purchase WinMe token with USDT
    function purchaseWinMeTokenWithERC20(IERC20 _tokenAddress) external {}

    function purchaseWinMeNftWithERC20() external {}

    // ADMIN FUNCTIONS

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
