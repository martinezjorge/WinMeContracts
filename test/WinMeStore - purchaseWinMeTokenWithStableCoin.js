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
  
  describe("WinMeStore-PurchaseWinMeTokenWithStableCoin", function () {
    describe("Approved Transactions", function () {
      it("Should let a user purchase WinMeToken with a stable coin", async function () {
        const {
          token,
          usdt,
          store,
          others: { addr1 },
        } = await loadFixture(deployTokenFixture);
        await store.setTokenInRegistry(usdt.target, 6, true);
        await usdt.connect(addr1).approve(store.target, ethers.parseUnits("4", "mwei"));
        // const usdtBalance = await usdt.balanceOf(addr1.address);
        // console.log(ethers.formatUnits(usdtBalance, "mwei"));
        await store.connect(addr1).purchaseWinMeTokenWithStableCoin(usdt.target, ethers.parseUnits("4", "mwei"));
        const userWinMeBalance = await token.balanceOf(addr1.address);
        console.log("WinMeToken Received", ethers.formatEther(userWinMeBalance));
      });
    });
  });
  