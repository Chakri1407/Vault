# 🏦Vault Contract - Decentralized Asset Vault

Welcome to the Vault Contract! This smart contract is an ERC4626-compliant vault that allows users to deposit, mint, withdraw, and redeem ERC-20 tokens while incorporating a fee system for operations. The vault is ideal for decentralized finance (DeFi) protocols that need to manage user assets securely while taking a fee on deposits.

## 🎯 Key Features

- #### ERC4626 Standard: The contract follows the ERC4626 standard, which defines tokenized vaults.
- #### Entry Fee Mechanism: Charges an entry fee (configurable in basis points) on deposits.
- #### Interest Fee: Automatically transfers a 10% fee to the vault owner from deposited assets as interest.

- #### Minting and Redeeming: Supports minting shares in exchange for assets and redeeming assets in exchange for shares.

- #### Customizable Hooks: Extendable internal logic with beforeWithdraw and afterDeposit hooks.

## 📝 Contract Details
- ### Contract has been Deployed and Verified on polygon amoy testnet with Contract Address - [0x7B7299A7626f2533309217e136F01c7Eb1c917A7](https://amoy.polygonscan.com/address/0x7B7299A7626f2533309217e136F01c7Eb1c917A7#code).
![1.](https://github.com/Chakri1407/Vault/blob/main/Assets/Verification.png)
![2.](https://github.com/Chakri1407/Vault/blob/main/Assets/Txs.png)

## 📦 Contract Structure

1. Vault Owner:

- The `vaultOwner` is the address that owns the contract and collects the fees.

2. Entry Fees:

- `entryFeeBasisPoints` determines the entry fee charged when users deposit into the vault. This fee is adjustable at deployment.

3. Deposit:

- Users deposit ERC-20 tokens into the vault and receive shares in return.

4. Minting:

- Mint new shares by providing assets, even if the vault has no value yet.

5. Withdrawals:

- Users can withdraw assets from the vault by redeeming shares.

6. Redeem:

- Redeem shares in exchange for the equivalent amount of assets.

## 📜 Functions Overview

### 🏦 Public Functions

- `deposit(uint256 assets, address receiver)`: Deposit assets into the vault, and the receiver will get vault shares in return.

- `mint(uint256 shares, address receiver)`: Mint new vault shares by providing the corresponding amount of assets.

- `withdraw(uint256 assets, address receiver, address owner)`: Withdraw assets by burning the owner's shares. The assets are transferred to the receiver.

- `redeem(uint256 shares, address receiver, address owner)`: Redeem shares for assets, transferring the assets to the receiver.

### 🔧 Internal Functions

- `_entryFeeBasisPoints()`: Returns the entry fee (in basis points) that is charged on deposits.

- `_entryFeeRecipient()`: Returns the recipient of the entry fees (the vault owner).

- `beforeWithraw(uint256 assets, uint256 shares)`: A hook that can be overridden to add custom logic before withdrawals.

- `afterDeposit(uint256 assets)`: A hook to handle logic after deposits. It automatically transfers 10% of the deposit as interest to the vault owner.

## 💡 Example Usage

1. Deploy the Vault:

- The vault owner deploys the contract by passing the ERC-20 token address and setting the entry fee basis points.

2. Deposit Tokens:

- A user can deposit tokens into the vault and receive shares in return.

3. Withdraw Tokens:

- A user can withdraw their tokens by burning their shares.

4. Redeem Shares:

- A user can redeem their shares for the corresponding assets.

## ⚖️ Fee Structure

- #### Entry Fee: The entryFeeBasisPoints is set during contract deployment. If the fee is set to 100 basis points, it means 1% of the deposit will be collected as a fee.

- #### Interest Fee: After every deposit, 10% of the deposited assets are transferred to the vaultOwner as an interest fee.

## 🚀 Getting Started

- ### Prerequisites
- Solidity 0.8.20+
- OpenZeppelin Contracts for SafeERC20 functionality.

### Installation

Clone the Repo:

- git clone https://github.com/Chakri1407/Vault
- cd vault-contract

### Install Dependencies:

You'll need to install the required libraries using a Solidity package manager such as npm or yarn.

- npm install @openzeppelin/contracts

### Compile the Contracts:

- Compile the contracts using Hardhat, Truffle, or Remix.

- npx hardhat compile

### 🔨 Contract Setup

To deploy the contract, pass the following parameters during the deployment:

- \_asset: The address of the ERC-20 token you want the vault to manage.
- \_basisPoints: The entry fee in basis points (e.g., 100 = 1%).
  Example:

solidity
Copy code
Vault vault = new Vault(0xTokenAddress, 100); // 1% entry fee
📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

### 📬 Contact

- Twitter: [![Static Badge](https://img.shields.io/badge/X-black)](https://x.com/Chakru0454)

- GitHub: [![Static Badge](https://img.shields.io/badge/github-black)](https://github.com/Chakri1407)

### 🛠️ Development

- #### Fork the Repo: Fork this repository to your GitHub account and clone it locally.

- Create Your Feature Branch: Create a branch for your feature:

- `git checkout -b feature/your-feature-name`

- Make Your Changes: Add your desired features and improvements.

- Submit a Pull Request: Submit a pull request to the main branch for review.

  ## 📜 License
This project is licensed under the MIT License.

## ✍️ Authors

- [@ChakravarthyN](https://github.com/Chakri1407)


## ❓FAQ

#### Question 
For any questions, please feel free to reach out to me at: [![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/chakravarthy-naik-9626bb1ba/)
