const { ethers } = require("hardhat");
const {
    impersonateAccount,
    setBalance,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");

async function deployTokenFixture() {
    const [owner, addr1, addr2, addr3, addr4, addr5, addr6, treasury] =
    await ethers.getSigners();

    const token = await ethers.deployContract("WinMeToken", []);
    await token.waitForDeployment();

    const ethUsdAddress = "0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419";
    await impersonateAccount(ethUsdAddress);

    const store = await ethers.deployContract("WinMeStore", [
        treasury.address,
        token.target,
        ethUsdAddress
    ]);
    await store.waitForDeployment();

    await token.grantMinterRole(store.target);

    const link = await ethers.getContractAt("ILINK", "0x514910771AF9Ca656af840dff83E8264EcF986CA");
    const luckyLinkHolder = "0x8B3Ce9e912d26f8a3dae6d8607384c73B4C267e9";
    await impersonateAccount(luckyLinkHolder);
    await setBalance(luckyLinkHolder, ethers.parseEther("10"));
    const linkHolder = await ethers.getImpersonatedSigner(luckyLinkHolder);
    await link.connect(linkHolder).transfer(store.target, ethers.parseEther("500"));


    const tetherAddress = "0xdAC17F958D2ee523a2206206994597C13D831ec7";
    const tetherHolderAddress = "0x4Ee7bBc295A090aD0F6db12fe7eE4dC8de896400";

    const usdt = await ethers.getContractAt("IUSDT", tetherAddress);
    await impersonateAccount(tetherHolderAddress);
    const usdtHolder = await ethers.getImpersonatedSigner(tetherHolderAddress);
    usdt.connect(usdtHolder).transfer(owner, ethers.utils.formatEthers("500", "gwei"));

    return {
        token,
        store,
        link,
        usdt,
        owner,
        others: {
            addr1,
            addr2,
            addr3,
            addr4,
            addr5,
            addr6,
            treasury,
        },
    };
}

module.exports = {
  deployTokenFixture,
};