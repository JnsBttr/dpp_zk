// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "../interfaces/IVerifier.sol";

contract ProductProofManager is OwnableUpgradeable, UUPSUpgradeable {
    struct ProductProof {
        address submitter;
        uint256 productId;
        uint256[] publicInputs;
        bytes proof;
        uint256 timestamp;
    }

    mapping(uint256 => ProductProof) public productProofs;

    IVerifier public verifier;

    event ProofSubmitted(uint256 indexed productId, address indexed submitter);

    function initialize(address verifierAddress) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        verifier = IVerifier(verifierAddress);
    }

    function submitProof(uint256 productId, uint256[] calldata publicInputs, bytes calldata proof) external {
        require(verifier.verifyProof(proof, publicInputs), "Invalid proof");

        productProofs[productId] = ProductProof({
            submitter: msg.sender,
            productId: productId,
            publicInputs: publicInputs,
            proof: proof,
            timestamp: block.timestamp
        });

        emit ProofSubmitted(productId, msg.sender);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}
