// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WinMeNftMarketplace is Ownable {
  mapping(address => mapping(uint256 => Listing)) public listings;
  mapping(address => ERC20Details) approvedTokenDetails;

  struct Listing {
      uint256 price;
      address seller;
  }

  struct ERC20Details {
      address token;
      uint decimals;
      bool approved;
  }

  event NFTTransfer(
      uint256 tokenID,
      address from,
      address to,
      string tokenURI,
      uint256 price
  );

  constructor() Ownable(msg.sender) {}

  function toggleTokens(
      address tokenAddress,
      uint decimals,
      bool approved
  ) external onlyOwner {
      approvedTokenDetails[tokenAddress] = ERC20Details(
          tokenAddress,
          decimals,
          approved
      );
  }

  function listNFT(IERC721 nft, uint256 tokenID, uint256 price) public {
      require(price > 0, "NFTMarket: price must be greater than 0");
      nft.transferFrom(msg.sender, address(this), tokenID);
      listings[address(nft)][tokenID] = Listing(price, msg.sender);
      emit NFTTransfer(tokenID, msg.sender, address(this), "", price);
  }

  function buyNFT(IERC721 nft, uint256 tokenID) public payable {
      Listing memory listing = listings[address(nft)][tokenID];
      require(listing.price > 0, "NFTMarket: nft not listed for sale");
      require(msg.value == listing.price, "NFTMarket: incorrect price");
      nft.transferFrom(address(this), msg.sender, tokenID);
      clearListing(address(nft), tokenID);
      payable(listing.seller).transfer((listing.price * 95) / 100);
      emit NFTTransfer(tokenID, address(this), msg.sender, "", 0);
  }

  function cancelListing(IERC721 nft, uint256 tokenID) public {
      Listing memory listing = listings[address(nft)][tokenID];
      require(listing.price > 0, "NFTMarket: nft not listed for sale");
      require(
          listing.seller == msg.sender,
          "NFTMarket: you're not the seller"
      );
      nft.transferFrom(address(this), msg.sender, tokenID);
      clearListing(address(nft), tokenID);
      emit NFTTransfer(tokenID, address(this), msg.sender, "", 0);
  }

  function withdrawFunds() public onlyOwner {
      uint256 balance = address(this).balance;
      require(balance > 0, "NFTMarket: balance is zero");
      payable(msg.sender).transfer(balance);
  }

  function clearListing(address nft, uint256 tokenID) private {
      listings[nft][tokenID].price = 0;
      listings[nft][tokenID].seller = address(0);
  }
}