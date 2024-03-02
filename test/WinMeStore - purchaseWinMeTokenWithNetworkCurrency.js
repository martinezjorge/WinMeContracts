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
  
  describe("WinMeStore-purchaseWinMeTokenWithNetworkCurrency", function () {
    describe("Approved Transactions", function () {
      it("WinMeStore should have a link balance", async function () {
        const {
          token,
          store,
          link,
          others: { treasury, addr3 },
        } = await loadFixture(deployTokenFixture);
        const storeBalance = await link.balanceOf(store.target);
        let tokenAmount = await store.winMeTokenAmount(ethers.parseEther("1"));
      });

      it("Should let a user purchase WinMeTokens using Network Currency", async function () {
        const {
          token,
          store,
          link,
          others: { addr1 },
        } = await loadFixture(deployTokenFixture);
        await store.connect(addr1).purchaseWinMeTokenWithNetworkCurrency({value: ethers.parseEther("1")});
        const userWinMeBalance = await token.balanceOf(addr1.address);
        console.log(ethers.formatEther(userWinMeBalance));
      });
    });
  
    // describe("Reverted Transactions", function () {});
  });
  