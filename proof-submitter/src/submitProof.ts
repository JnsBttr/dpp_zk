import { createPublicClient, createWalletClient, http } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { config } from './config';
import fs from 'fs';
import { logInfo, logError } from './utils';

const abi = [
  {
    name: 'submitProof',
    type: 'function',
    stateMutability: 'nonpayable',
    inputs: [
      { name: 'productId', type: 'uint256' },
      { name: 'publicInputs', type: 'uint256[]' },
      { name: 'proof', type: 'bytes' }
    ],
    outputs: []
  }
];

export const submitProof = async (
  productId: number,
  proofPath: string,
  publicInputsPath: string
) => {
  try {
    const publicClient = createPublicClient({
      transport: http(config.rpcUrl),
    });

    const account = privateKeyToAccount(config.privateKey);
    const walletClient = createWalletClient({
      account,
      transport: http(config.rpcUrl),
    });

    const proof = fs.readFileSync(proofPath, 'utf8');
    const publicInputs = JSON.parse(fs.readFileSync(publicInputsPath, 'utf8'));

    const { request } = await publicClient.simulateContract({
      account,
      address: config.contractAddress,
      abi,
      functionName: 'submitProof',
      args: [productId, publicInputs, proof],
    });

    const txHash = await walletClient.writeContract(request);
    logInfo(`Proof submitted successfully. TX Hash: ${txHash}`);
  } catch (error) {
    logError(`Error submitting proof: ${error}`);
  }
};
