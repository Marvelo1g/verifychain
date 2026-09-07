// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VerifyChain is ERC721, Ownable {

    bytes4 private constant _INTERFACE_ID_EIP5192 = 0xb45a3c0e;

    uint256 private _nextTokenId;

    mapping(address => bool) public isIssuer;

    struct Credential {
        string  recipientName;
        string  credentialType;
        string  issuingBody;
        uint256 issuedAt;
    }

    mapping(uint256 => Credential) public credentials;

    event Locked(uint256 tokenId);
    event CredentialIssued(
        address indexed recipient,
        uint256 indexed tokenId,
        string  credentialType,
        string  issuingBody
    );
    event IssuerAdded(address indexed issuer);
    event IssuerRemoved(address indexed issuer);

    modifier onlyIssuer() {
        require(isIssuer[msg.sender], "VerifyChain: not an authorized issuer");
        _;
    }

    constructor(address initialOwner)
        ERC721("VerifyChain", "VCN")
        Ownable(initialOwner)
    {
        isIssuer[initialOwner] = true;
        emit IssuerAdded(initialOwner);
    }

    function addIssuer(address issuer) external onlyOwner {
        isIssuer[issuer] = true;
        emit IssuerAdded(issuer);
    }

    function removeIssuer(address issuer) external onlyOwner {
        isIssuer[issuer] = false;
        emit IssuerRemoved(issuer);
    }

    function issueCredential(
        address to,
        string memory recipientName,
        string memory credentialType,
        string memory issuingBody
    ) external onlyIssuer returns (uint256) {
        uint256 tokenId = _nextTokenId++;

        credentials[tokenId] = Credential({
            recipientName:  recipientName,
            credentialType: credentialType,
            issuingBody:    issuingBody,
            issuedAt:       block.timestamp
        });

        _safeMint(to, tokenId);

        emit Locked(tokenId);
        emit CredentialIssued(to, tokenId, credentialType, issuingBody);

        return tokenId;
    }

    function locked(uint256) external pure returns (bool) {
        return true;
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override returns (address) {
        address from = _ownerOf(tokenId);

        if (from != address(0)) {
            revert("VerifyChain: soulbound - token cannot be transferred");
        }

        return super._update(to, tokenId, auth);
    }

    function supportsInterface(bytes4 interfaceId)
        public view override
        returns (bool)
    {
        return
            interfaceId == _INTERFACE_ID_EIP5192 ||
            super.supportsInterface(interfaceId);
    }
}