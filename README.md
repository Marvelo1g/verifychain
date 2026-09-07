# VerifyChain

**Soulbound credentials, verified instantly, on-chain.**

VerifyChain is a decentralized credential verification system built on Ethereum. Institutions issue tamper-proof credentials as soulbound (non-transferable) NFTs directly to a recipient's wallet, and anyone in the world can verify those credentials instantly by looking up a wallet address — no login, no fees, no middlemen.

🔗 **Live demo:** [verifychain-wine.vercel.app](https://verifychain-wine.vercel.app/)
📜 **Contract (Sepolia testnet):** [`0x1a5b6e9A9eD01e3E174e3BBB4E2BE59876E929F6`](https://sepolia.etherscan.io/address/0x1a5b6e9A9eD01e3E174e3BBB4E2BE59876E929F6)

---

## The Problem

Credentials today — degrees, certificates, professional licenses — are mostly PDFs or paper documents. They're easy to forge, slow to verify, and depend on trusting a third party (a registrar's office, a verification service) to confirm they're genuine. Employers often have to contact institutions directly or pay for verification services just to confirm a candidate's degree is real. This is slow, costly, and in many regions, a real barrier to opportunity.

## The Solution

VerifyChain puts credentials directly on a public blockchain as **soulbound tokens** — NFTs permanently bound to one wallet that can never be transferred, sold, or forged. Once issued, a credential is:

- **Permanent** — stored on Ethereum forever, no risk of loss
- **Tamper-proof** — cannot be altered or faked after issuance
- **Instantly verifiable** — anyone can check any wallet's credentials for free, in seconds
- **Owned by the recipient** — no dependency on the issuing institution staying reachable or in business

## How It Works

1. **Issue** — An authorized institution connects their wallet and calls `issueCredential`, minting a soulbound NFT directly to the recipient's wallet.
2. **Bind** — The token locks permanently to that wallet. Enforced at the smart contract level (EIP-5192 compliant) — no transfer will ever succeed.
3. **Verify** — Anyone — an employer, another institution, or an individual — can paste a wallet address into the Verify page and instantly see every credential that wallet legitimately holds.

## Multi-Issuer Support

Rather than relying on a single trusted admin, VerifyChain uses an on-chain issuer allowlist. The contract owner can approve additional wallets — other institutions, bootcamps, or organizations — as authorized issuers, so credentialing isn't bottlenecked through one gatekeeper. Ownership and issuer management stay separate: the owner controls *who* can issue, but doesn't need to personally issue every credential.

## Tech Stack

- **Smart contract:** Solidity, OpenZeppelin (ERC-721, Ownable), Hardhat + Hardhat Ignition
- **Frontend:** HTML, CSS, JavaScript, [Viem](https://viem.sh/) for contract reads/writes
- **Network:** Ethereum Sepolia testnet
- **Hosting:** Vercel

## Project Structure

```
verifychain/
├── contracts/
│   └── VerifyChain.sol        # Main soulbound credential contract
├── ignition/
│   └── modules/
│       └── VerifyChain.ts     # Deployment module
├── frontend/
│   ├── index.html             # Landing page
│   ├── issue.html             # Institution portal — issue credentials, manage issuers
│   └── verify.html            # Public verification page
└── test/                      # Contract tests
```

## Running Locally

```bash
git clone https://github.com/Marvelo1g/verifychain.git
cd verifychain
npm install
```

Create a `.env` file in the project root:

```
SEPOLIA_RPC_URL=your_alchemy_or_infura_sepolia_url
PRIVATE_KEY=your_wallet_private_key
```

Deploy to Sepolia:

```bash
npx hardhat ignition deploy ./ignition/modules/VerifyChain.ts --network sepolia
```

Then open any file in `frontend/` in your browser (or serve the folder statically) to use the app locally.

## Roadmap

- [ ] Mainnet deployment
- [ ] Public verification API for HR platforms and background check services
- [ ] Batch credential issuance
- [ ] Revocation mechanism for institutions to invalidate wrongly issued credentials
- [ ] IPFS-hosted credential metadata for richer credential details

## Why This Matters

Credential fraud and slow verification disproportionately affect job seekers and institutions in regions without easy access to fast, trusted verification infrastructure. VerifyChain turns credential verification into a public good — free, instant, and accessible to anyone with an internet connection, anywhere in the world.

## License

MIT
