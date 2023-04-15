import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import "hardhat-gas-reporter";
import "hardhat-abi-exporter";
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
    alfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      accounts: [process.env.WALLET_PIRVATE_KEY || ""],
      chainId: 44787,
    },
    linea: {
      url: `https://rpc.goerli.linea.build/`,
      accounts: [process.env.WALLET_PIRVATE_KEY || ""],
    },
    polygonZkevm: {
      url: "https://polygonzkevm-testnet.g.alchemy.com/v2/PZ3dfQSH8ReSmzuFAVCTrYyBZCXmEDFQ",
      accounts: [process.env.WALLET_PIRVATE_KEY || ""],
    },
    scrollAlpha: {
      url: "https://alpha-rpc.scroll.io/12" || "",
      accounts: [process.env.WALLET_PIRVATE_KEY || ""],
    },
  },
  gasReporter: {
    gasPriceApi:
      "https://api.etherscan.io/api?module=proxy&action=eth_gasPrice",
    enabled: true,
  },
  etherscan: {
    apiKey: process.env.ETHSCAN_API_KEY || "",
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
