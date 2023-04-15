import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan";
import "@openzeppelin/hardhat-upgrades";
import "hardhat-gas-reporter";
import "hardhat-abi-exporter";
// import "hardhat-celo";
import dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {},
    polygonMumbai: {
      url: "https://polygon-mumbai.infura.io/v3/82dca944771944fc83df032e7dc6a288",
      accounts: [process.env.WALLET_PIRVATE_KEY || ""],
    },
    alfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      accounts: [process.env.WALLET_PIRVATE_KEY || ""],
      chainId: 44787,
    },
    linea: {
      url: `https://rpc.goerli.linea.build/`,
      accounts: [process.env.WALLET_PIRVATE_KEY || ""],
      chainId: 59140,
    },
    zkEVM: {
      url: "https://rpc.public.zkevm-test.net",
      accounts: [process.env.WALLET_PIRVATE_KEY || ""],
    },
    scrollAlpha: {
      url: "https://alpha-rpc.scroll.io/l2" || "",
      accounts: [process.env.WALLET_PIRVATE_KEY || ""],
      chainId: 534353,
    },
  },
  gasReporter: {
    gasPriceApi:
      "https://api.etherscan.io/api?module=proxy&action=eth_gasPrice",
    enabled: true,
  },
  etherscan: {
    apiKey: {
      scrollAlpha: "abc",
      polygonMumbai: process.env.MUMBAI_API_KEY || "",
      // alfajores: process.env.CELO_API_KEY || "",
      linea: process.env.ETHERSCAN_API_KEY || "",
      zkEVM: process.env.POLYGON_ZKEVM_API_KEY || "",
    },
    customChains: [
      {
        network: "scrollAlpha",
        chainId: 534353,
        urls: {
          apiURL: "https://blockscout.scroll.io/api",
          browserURL: "https://blockscout.scroll.io/",
        },
      },
      {
        network: "linea",
        chainId: 59140,
        urls: {
          apiURL: "https://explorer.goerli.linea.build/api",
          browserURL: "https://explorer.goerli.linea.build/",
        },
      },
      {
        network: "zkEVM",
        chainId: 1442,
        urls: {
          apiURL: "https://api-testnet-zkevm.polygonscan.com/api",
          browserURL: "https://testnet-zkevm.polygonscan.com/",
        },
      },
    ],
  },
  abiExporter: [
    {
      path: "./abi/pretty",
      pretty: true,
    },
    {
      path: "./abi/ugly",
      pretty: false,
    },
  ],
};

export default config;
