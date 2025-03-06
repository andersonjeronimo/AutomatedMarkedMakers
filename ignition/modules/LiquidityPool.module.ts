// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const LiqPoolModule = buildModule("LiqPoolModule", (m) => {

  const token0 = m.contract("AlfaCoin");
  const token1 = m.contract("BetaCoin");
  const pool = m.contract("LiquidityPool");
  //inserir approve de token0 e token1 para a pool 
  m.call(pool, "addTokenPair", [token0, token1]);

  return { pool };
});

export default LiqPoolModule;
