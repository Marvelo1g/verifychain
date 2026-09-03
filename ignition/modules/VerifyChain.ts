import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const VerifyChainModule = buildModule("VerifyChainModule", (m) => {
  const deployer = m.getAccount(0);
  const verifyChain = m.contract("VerifyChain", [deployer]);
  return { verifyChain };
});

export default VerifyChainModule;