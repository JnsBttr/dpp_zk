const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("ProductProofManager", function () {
  let ProductProofManager, productProofManager, owner, verifier;

  beforeEach(async function () {
    [owner] = await ethers.getSigners();

    const Verifier = await ethers.getContractFactory("Verifier");
    verifier = await Verifier.deploy();

    ProductProofManager = await ethers.getContractFactory("ProductProofManager");
    productProofManager = await upgrades.deployProxy(ProductProofManager, [verifier.address]);
    await productProofManager.waitForDeployment();
  });

  it("should successfully submit and verify a proof", async function () {
    const productId = 1;
    const publicInputs = [123, 456];
    const proof = ethers.encodeBytes32String("dummyProof");

    await expect(productProofManager.submitProof(productId, publicInputs, proof))
      .to.emit(productProofManager, "ProofSubmitted")
      .withArgs(productId, owner.address);

    const storedProof = await productProofManager.productProofs(productId);
    expect(storedProof.submitter).to.equal(owner.address);
  });
});
