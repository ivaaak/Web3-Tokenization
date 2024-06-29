/*
This ethereum.ts file sets up the configuration for interacting with the Ethereum blockchain. Here's a breakdown of its contents:

Import necessary dependencies, including ethers.js and dotenv for environment variables.
Define network configurations for different Ethereum networks (mainnet, testnet).
Set the current network based on an environment variable or default to a testnet.
Create an Ethereum provider using the RPC URL for the current network.
Set up a wallet using a private key from the environment variables. This wallet can be used for server-side transactions if needed.
Define a gas price adjustment factor for potentially faster transactions.
Store contract addresses, retrieved from environment variables.
Create a configuration object that includes:

The provider and wallet instances
Current network information
Gas price adjustment factor
Contract addresses
A function to get the current gas price with the adjustment applied


This configuration can be imported and used throughout your application to interact with the Ethereum blockchain, ensuring consistent settings and easy management of network-specific details.
Remember to store sensitive information like private keys and RPC URLs in environment variables and never commit them to version control.
*/

import { ethers } from 'ethers';
import dotenv from 'dotenv';

dotenv.config();

// Network configurations
const NETWORKS = {
  mainnet: {
    chainId: 1,
    name: 'Ethereum Mainnet',
    rpcUrl: process.env.MAINNET_RPC_URL,
  },
  goerli: {
    chainId: 5,
    name: 'Goerli Testnet',
    rpcUrl: process.env.GOERLI_RPC_URL,
  },
  // Add more networks as needed
};

// Current network (can be set via environment variable)
const CURRENT_NETWORK = process.env.ETHEREUM_NETWORK || 'goerli';

// Provider setup
const provider = new ethers.providers.JsonRpcProvider(
  NETWORKS[CURRENT_NETWORK].rpcUrl
);

// Wallet setup (for server-side transactions)
const privateKey = process.env.ETHEREUM_PRIVATE_KEY;
const wallet = new ethers.Wallet(privateKey, provider);

// Gas price settings
const GAS_PRICE_ADJUSTMENT = 1.2; // 20% increase for faster transactions

// Contract addresses
const CONTRACT_ADDRESSES = {
  SneakerToken: process.env.SNEAKER_TOKEN_ADDRESS,
  Marketplace: process.env.MARKETPLACE_ADDRESS,
};

// Ethereum configuration object
const ethereumConfig = {
  provider,
  wallet,
  network: NETWORKS[CURRENT_NETWORK],
  gasAdjustment: GAS_PRICE_ADJUSTMENT,
  contracts: CONTRACT_ADDRESSES,
  getGasPrice: async () => {
    const baseGasPrice = await provider.getGasPrice();
    return baseGasPrice.mul(Math.floor(GAS_PRICE_ADJUSTMENT * 100)).div(100);
  },
};

export default ethereumConfig;