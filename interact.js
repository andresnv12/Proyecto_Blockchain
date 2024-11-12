const hre = require("hardhat");

async function main() {

  try {
    const SimpleContractFactory = await hre.ethers.getContractFactory("SimpleContract");
    const contractAddress = "0xCAFE"; // Replace with your deployed contract address
    const contractJS = await SimpleContractFactory.attach(contractAddress);

	const data = await contractJS.getData();
		
	console.log("The data of the contract is: ", data.toString());
	
	const operand=13;
	
	const dataOperated=await contractJS.accumulateData(operand);
	dataOperated.wait(1);
		
    }
   catch (error) {

    console.error(error);

    process.exit(1);

  }
}
main();