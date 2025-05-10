import { submitProof } from './submitProof';

const productId = parseInt(process.argv[2], 10);
const proofPath = process.argv[3];
const publicInputsPath = process.argv[4];

if (!productId || !proofPath || !publicInputsPath) {
  console.log('Usage: tsx src/index.ts <productId> <proofPath> <publicInputsPath>');
  process.exit(1);
}

submitProof(productId, proofPath, publicInputsPath);
