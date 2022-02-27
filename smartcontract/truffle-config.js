const HDWalletProvider = require("@truffle/hdwallet-provider");
const fs = require("fs");
const mnemonic = "spin you chair captain insane seat future unknown assume help such copy"
//fs.readFileSync("qrious.secret").toString().trim();

var DATAHUB_API_KEY = "fa1cec0afc2c6ba950b59823681cba36";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*",
    },
    matic: {
      networkCheckTimeout: 999999,
      provider: () =>
        new HDWalletProvider({
          mnemonic: {
            phrase: mnemonic,
          },
          provider: `https://matic-mumbai--rpc.datahub.figment.io/apikey/fa1cec0afc2c6ba950b59823681cba36/`,
          chainId: 80001,
        }),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      chainId: 80001,
    },
  },
  contracts_directory: "./contracts",
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  db: {
    enabled: false,
  },
};