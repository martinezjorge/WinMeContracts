const {
    loadFixture,
    impersonateAccount,
    setBalance,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  require("@nomicfoundation/hardhat-ethers");
  const { expect } = require("chai");
  const { ethers } = require("hardhat");
  const moment = require("moment");
  const { deployTokenFixture } = require("../common/test-common");
  
  describe("WinMeStore-purchaseWinMeNftWithWinMeToken", function () {
    describe("Approved Transactions", function () {
      it("Should let a user purchase WinMeNfts using WinMeTokens", async function () {
        const {
          token,
          store,
          link,
          others: { addr1 },
        } = await loadFixture(deployTokenFixture);
        await store.connect(addr1).purchaseWinMeTokenWithNetworkCurrency({value: ethers.parseEther("1")});
        await token.connect(addr1).approve(store.target, ethers.parseEther("20"));
        await store.connect(addr1).purchaseWinMeNftWithWinMeToken();
      });
    });
  
    // describe("Reverted Transactions", function () {});
  });
  