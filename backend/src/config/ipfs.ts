/*
This ipfs.ts file sets up the configuration for interacting with IPFS (InterPlanetary File System). Here's a breakdown of its contents:

Import necessary dependencies, including the IPFS HTTP client and dotenv for environment variables.
Load environment variables for IPFS project ID and secret. These are typically provided by IPFS hosting services like Infura.
Set up the IPFS gateway URL, which is used to access files stored on IPFS.
Create an IPFS client instance using the project ID and secret for authentication. This example uses Infura's IPFS service, but you can modify it for other providers or a local IPFS node.
Wrap the client creation in a try-catch block to handle potential initialization errors.
Create a configuration object that includes:

The IPFS client instance
The IPFS gateway URL
An addFile function to upload files to IPFS
A getFile function to retrieve files from IPFS
A getUrl function to generate a public URL for accessing files via the IPFS gateway



This configuration can be imported and used throughout your application to interact with IPFS, providing a consistent interface for file storage and retrieval.
Key points to note:

The addFile function takes a Buffer and returns the CID (Content Identifier) of the uploaded file.
The getFile function retrieves a file from IPFS given its CID.
The getUrl function generates a public URL for accessing the file through the IPFS gateway.

Remember to store sensitive information like project IDs and secrets in environment variables and never commit them to version control.
*/

import { create, IPFSHTTPClient } from 'ipfs-http-client';
import dotenv from 'dotenv';

dotenv.config();

// IPFS configuration
const IPFS_PROJECT_ID = process.env.IPFS_PROJECT_ID;
const IPFS_PROJECT_SECRET = process.env.IPFS_PROJECT_SECRET;
const IPFS_GATEWAY = process.env.IPFS_GATEWAY || 'https://ipfs.io/ipfs/';

let ipfs: IPFSHTTPClient | undefined;

try {
  const auth = 'Basic ' + Buffer.from(IPFS_PROJECT_ID + ':' + IPFS_PROJECT_SECRET).toString('base64');

  ipfs = create({
    host: 'ipfs.infura.io',
    port: 5001,
    protocol: 'https',
    headers: {
      authorization: auth,
    },
  });
} catch (error) {
  console.error('IPFS client creation failed', error);
  ipfs = undefined;
}

const ipfsConfig = {
  client: ipfs,
  gateway: IPFS_GATEWAY,
  addFile: async (file: Buffer) => {
    if (!ipfs) throw new Error('IPFS client not initialized');
    const result = await ipfs.add(file);
    return result.path;
  },
  getFile: async (cid: string) => {
    if (!ipfs) throw new Error('IPFS client not initialized');
    const stream = ipfs.cat(cid);
    const chunks = [];
    for await (const chunk of stream) {
      chunks.push(chunk);
    }
    return Buffer.concat(chunks);
  },
  getUrl: (cid: string) => {
    return `${IPFS_GATEWAY}${cid}`;
  },
};

export default ipfsConfig;