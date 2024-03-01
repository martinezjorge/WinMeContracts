// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WinMeNftMarketplace is ERC721URIStorage, Ownable {

  mapping(uint256 => NFTListing) private _listings;
  mapping(address => ERC20Details) approvedTokenDetails;

  struct NFTListing {
    uint256 price;
    address seller;
  }

  struct ERC20Details {
      address token;
      uint decimals;
      bool approved;
  }

  event NFTTransfer(uint256 tokenID, address from, address to, string tokenURI, uint256 price);

  constructor(address initialOwner) ERC721("Winme", "ANFT") Ownable(initialOwner) {}

  function toggleTokens(address tokenAddress, uint decimals, bool approval) external onlyOwner {
    approvedTokenDetails[tokenAddress] = ERC20Details(tokenAddress, decimals, approval);
  }

  function listNFT(uint256 tokenID, uint256 price) public {
    require(price > 0, "NFTMarket: price must be greater than 0");
    transferFrom(msg.sender, address(this), tokenID);
    _listings[tokenID] = NFTListing(price, msg.sender);
    emit NFTTransfer(tokenID, msg.sender, address(this), "", price);
  }

  function buyNFT(uint256 tokenID) public payable {
     NFTListing memory listing = _listings[tokenID];
     require(listing.price > 0, "NFTMarket: nft not listed for sale");
     require(msg.value == listing.price, "NFTMarket: incorrect price"); 
     ERC721(address(this)).transferFrom(address(this), msg.sender, tokenID);
     clearListing(tokenID);
     payable(listing.seller).transfer(listing.price * 95 / 100);
     emit NFTTransfer(tokenID, address(this), msg.sender, "", 0);
  }

  function cancelListing(uint256 tokenID) public {
     NFTListing memory listing = _listings[tokenID];
     require(listing.price > 0, "NFTMarket: nft not listed for sale");
     require(listing.seller == msg.sender, "NFTMarket: you're not the seller");
     ERC721(address(this)).transferFrom(address(this), msg.sender, tokenID);
     clearListing(tokenID);
     emit NFTTransfer(tokenID, address(this), msg.sender, "", 0);
  }

  function withdrawFunds() public onlyOwner {
    uint256 balance =  address(this).balance;
    require(balance > 0, "NFTMarket: balance is zero");
    payable(msg.sender).transfer(balance); 
  }

  function clearListing(uint256 tokenID) private {
    _listings[tokenID].price = 0;
    _listings[tokenID].seller= address(0);
  }
}