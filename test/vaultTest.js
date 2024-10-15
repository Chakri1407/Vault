const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Vault Contract", function () {
  let Vault, vault;
  let owner, user1, user2;
  let token, assetAmount;
  const basisPoints = 100; // Entry fee: 1%

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();

    // Deploy a mock ERC20 token for testing
    const Token = await ethers.getContractFactory("TestToken");
    token = await Token.deploy("Test Token", "TT", ethers.utils.parseEther("1000"));
    await token.deployed();

    // Deploy the Vault contract
    Vault = await ethers.getContractFactory("Vault");
    vault = await Vault.deploy(token.address, basisPoints);
    await vault.deployed();

    // Mint some tokens to user1
    assetAmount = ethers.utils.parseEther("100");
    await token.transfer(user1.address, assetAmount);
  });

  it("Should initialize with correct parameters", async function () {
    expect(await vault.asset()).to.equal(token.address);
    expect(await vault._entryFeeBasisPoints()).to.equal(basisPoints);
    expect(await vault._entryFeeRecipient()).to.equal(owner.address);
  });

  it("Should allow deposits and issue shares", async function () {
    // User1 approves Vault to spend tokens
    await token.connect(user1).approve(vault.address, assetAmount);

    // User1 deposits tokens into the Vault
    await expect(vault.connect(user1).deposit(assetAmount, user1.address))
      .to.emit(vault, "Deposit")
      .withArgs(user1.address, user1.address, assetAmount, assetAmount); // Same amount of shares as tokens (1:1)

    // Verify balance of vault shares
    const userShares = await vault.balanceOf(user1.address);
    expect(userShares).to.equal(assetAmount);
  });

  it("Should deduct entry fee on deposit", async function () {
    // User1 approves Vault to spend tokens
    await token.connect(user1).approve(vault.address, assetAmount);

    // User1 deposits tokens
    await vault.connect(user1).deposit(assetAmount, user1.address);

    // Verify that the fee was transferred to the vault owner (1% fee)
    const ownerBalance = await token.balanceOf(owner.address);
    const expectedFee = assetAmount.mul(basisPoints).div(10000); // 1% fee
    expect(ownerBalance).to.equal(expectedFee);
  });

  it("Should allow withdrawals and burn shares", async function () {
    // User1 approves Vault to spend tokens
    await token.connect(user1).approve(vault.address, assetAmount);

    // User1 deposits tokens
    await vault.connect(user1).deposit(assetAmount, user1.address);

    // User1 withdraws tokens
    await expect(vault.connect(user1).withdraw(assetAmount, user1.address, user1.address))
      .to.emit(vault, "Withdraw")
      .withArgs(user1.address, user1.address, user1.address, assetAmount, assetAmount);

    // Verify user balance
    const userBalance = await token.balanceOf(user1.address);
    expect(userBalance).to.equal(assetAmount); // All tokens returned
  });

  it("Should mint shares and charge correct fee", async function () {
    const sharesToMint = ethers.utils.parseEther("50"); // Mint 50 shares

    // User1 approves Vault to spend tokens
    await token.connect(user1).approve(vault.address, assetAmount);

    // User1 mints shares
    await vault.connect(user1).mint(sharesToMint, user1.address);

    // Verify shares were minted
    const userShares = await vault.balanceOf(user1.address);
    expect(userShares).to.equal(sharesToMint);

    // Check that the correct fee has been transferred to the vault owner
    const expectedFee = sharesToMint.mul(basisPoints).div(10000); // 1% fee on mint
    const ownerBalance = await token.balanceOf(owner.address);
    expect(ownerBalance).to.equal(expectedFee);
  });

  it("Should handle redeem and return assets", async function () {
    // User1 approves Vault to spend tokens
    await token.connect(user1).approve(vault.address, assetAmount);

    // User1 deposits tokens and gets shares
    await vault.connect(user1).deposit(assetAmount, user1.address);

    const shares = await vault.balanceOf(user1.address);

    // User1 redeems shares
    await vault.connect(user1).redeem(shares, user1.address, user1.address);

    // Check user's asset balance after redeeming
    const userBalance = await token.balanceOf(user1.address);
    expect(userBalance).to.equal(assetAmount);
  });
});
