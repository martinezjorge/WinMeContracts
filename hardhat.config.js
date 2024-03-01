require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-foundry");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      forking: {
        url: `https://mainnet.infura.io/v3/${CONFIG[0]}`,
        blockNumber: 19267162,
      }
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${CONFIG[0]}`,
      accounts: [CONFIG[2]],
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${CONFIG[1]}`,
      accounts: [CONFIG[3]],
    },
  },
};