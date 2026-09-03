import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { network } from "hardhat";

describe("VerifyChain", async function () {

  const { viem } = await network.getOrCreate();

  const wallets = await viem.getWalletClients();
  const owner = wallets[0];
  const student = wallets[1];
  const stranger = wallets[2];

  const contract = await viem.deployContract("VerifyChain", [owner.account.address]);

  it("Should deploy with correct name and symbol", async function () {
    const name = await contract.read.name();
    const symbol = await contract.read.symbol();
    assert.equal(name, "VerifyChain");
    assert.equal(symbol, "VCN");
  });

  it("Should issue a credential successfully", async function () {
    await contract.write.issueCredential([
      student.account.address,
      "Alice Johnson",
      "Bachelor of Science",
      "MIT"
    ]);

    const ownerOf = await contract.read.ownerOf([0n]);
    assert.equal(ownerOf.toLowerCase(), student.account.address.toLowerCase());
  });

  it("Should store credential data correctly", async function () {
    const credential = await contract.read.credentials([0n]);
    assert.equal(credential[0], "Alice Johnson");
    assert.equal(credential[1], "Bachelor of Science");
    assert.equal(credential[2], "MIT");
  });

  it("Should block all transfers (soulbound)", async function () {
    await assert.rejects(
      async () => {
        await contract.write.transferFrom([
          student.account.address,
          stranger.account.address,
          0n
        ], { account: student.account });
      },
      /soulbound/
    );
  });

  it("Should block non-owners from issuing credentials", async function () {
    await assert.rejects(
      async () => {
        await contract.write.issueCredential([
          student.account.address,
          "Fake Degree",
          "PhD in Nothing",
          "Scam University"
        ], { account: stranger.account });
      },
      /OwnableUnauthorizedAccount|not the owner/
    );
  });

  it("Should return locked = true for all tokens", async function () {
    const isLocked = await contract.read.locked([0n]);
    assert.equal(isLocked, true);
  });

});