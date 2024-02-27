// Importing the necessary libraries
const { ethers } = require("hardhat");
async function main() {
    console.log("Deploying AirDrop V2");
    const AirDropV2 = await ethers.getContractFactory("AirDropV2");
    
const airdropV2 = await AirDropV2.deploy(); 
await airdropV2.waitForDeployment();
const airdropAddress = await airdropV2.getAddress();
console.log("AirDrop V2 deployed to:", airdropAddress);



  }
  
  main();
  