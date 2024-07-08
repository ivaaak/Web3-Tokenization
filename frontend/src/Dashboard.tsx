// App.js
import { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import contractABIImport from '../../blockchain/contracts/abis/Marketplace.json';
import './App.css';
import TitleSection from './components/TitleSection/TitleSection';
import mockContract from './mockContractData';

const contractAddress = '0x0000000000000000000000000000000000000000';

// Extract the ABI from the import
const contractABI = contractABIImport.abi;

declare global {
  interface Window {
    ethereum?: any;
  }
}

function Dashboard() {
  const [account, setAccount] = useState('');
  const [balance, setBalance] = useState('');
  const [contractData, setContractData] = useState({});

  useEffect(() => {
    connectWallet();
  }, []);

  const connectWallet = async () => {
    if (typeof window.ethereum !== 'undefined') {
      try {
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        const provider = new ethers.BrowserProvider(window.ethereum);
        const signer = await provider.getSigner();
        
        const address = await signer.getAddress();
        setAccount(address);
  
        const balance = await provider.getBalance(address);
        setBalance(ethers.formatEther(balance));
  
        // Create a contract instance
        //const contract = new ethers.Contract(contractAddress, contractABI, signer);
        
        const contract = mockContract;

        const data = await contract.getData(); // Replace with your actual contract method
        setContractData(data);
  
        console.log('Wallet connected successfully');
      } catch (error) {
        console.error('Error connecting to wallet:', error);
      }
    } else {
      console.log('Please install MetaMask');
    }
  };

  const handleTransaction = async () => {
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const contract = new ethers.Contract(contractAddress, contractABI, signer);
  
      const tx = await contract.someFunction(); // Replace with your contract method
      await tx.wait();
      console.log('Transaction successful');
  
      // Update data after transaction
      const newData = await contract.getData();
      setContractData(newData);
    } catch (error) {
      console.error('Error in transaction:', error);
    }
  };

  return (
    <div className="dashboard">
      <TitleSection/>
      <h1>dApp Dashboard</h1>
      <div>
        <h2>Account: {account}</h2>
        <h3>Balance: {balance} ETH</h3>
      </div>
      <div>
        <h2>Contract Data:</h2>
        <pre>{JSON.stringify(contractData, null, 2)}</pre>
      </div>
      <button onClick={handleTransaction}>Perform Transaction</button>
    </div>
  );
}

export default Dashboard;