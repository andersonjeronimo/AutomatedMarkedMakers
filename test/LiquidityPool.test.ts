import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("Liquidity Pool deploy", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  const ONE_ETH = hre.ethers.parseEther("1");
  const ETH_IN_WEI = Number(hre.ethers.parseUnits("1", "ether"));//1 * 10 ** 18;

  async function deployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const AlfaCoin = await hre.ethers.getContractFactory("AlfaCoin");
    const alfa = await AlfaCoin.deploy();
    const BetaCoin = await hre.ethers.getContractFactory("BetaCoin");
    const beta = await BetaCoin.deploy();

    const LiquidityPoll = await hre.ethers.getContractFactory("LiquidityPoll");
    const pool = await LiquidityPoll.deploy();

    //token.approve(spender, amount)
    await alfa.approve(pool.target, ONE_ETH);
    await beta.approve(pool.target, ONE_ETH);
    await pool.addTokenPair(alfa.target, beta.target);

    return { pool, alfa, beta, owner, otherAccount };
  }

  it("Should set the right owner", async function () {
    const { pool, owner } = await loadFixture(deployFixture);
    expect(await pool.owner()).to.equal(owner.address);
  });

  it("Should add liquidity (DEPOSIT)", async function () {
    const { pool } = await loadFixture(deployFixture);
    await pool.addLiquidity(ONE_ETH, ONE_ETH);
  });


  it("Should WITHDRAW", async function () {
    const { pool } = await loadFixture(deployFixture);
    
  });


  it("Should SWAP", async function () {
    const { pool } = await loadFixture(deployFixture);
    
  });


});
