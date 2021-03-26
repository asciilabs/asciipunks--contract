const HDWalletProvider = require("@truffle/hdwallet-provider");
const fs = require("fs");
const web3 = require('web3');
require("dotenv").config();

module.exports = {
  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  networks: {
    development: {
      host: "127.0.0.1", // Localhost (default: none)
      port: 8545, // Standard Ethereum port (default: none)
      network_id: "*", // Any network (default: none)
      websockets: true,
    },
    mainnet: {
      provider: () =>
        new HDWalletProvider(
          process.env.MNEMONIC,
          process.env.INFURA_MAINNET_URL
        ),
      network_id: 1,
      gas: 100000,
      gasPrice: web3.utils.toWei(process.env.GAS_PRICE || '130', 'gwei'),
      skipDryRun: true,
    },
    rinkeby: {
      provider: () =>
        new HDWalletProvider(
          process.env.MNEMONIC,
          process.env.INFURA_RINKEBY_URL
        ),
      network_id: 4,
      gas: 100000,
      skipDryRun: true,
    },
  },

  mocha: {
    // timeout: 100000
  },

  compilers: {
    solc: {
      version: "0.8.3",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
  },
};
