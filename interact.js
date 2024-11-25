const hre = require("hardhat");

async function main() {

  try {
    //const SimpleContractFactory = await hre.ethers.getContractFactory("SimpleContract");
    //const contractAddress = "0xCAFE"; // Replace with your deployed contract address
    //const contractJS = await SimpleContractFactory.attach(contractAddress);

    //CrowdFunding 
    const CFFactory = await hre.ethers.getContractFactory("CrowdFunding");
    const CFcontractAddress = ""; // Replace with your deployed contract address
    const CFcontractJS = await SimpleContractFactory.attach(CFcontractAddress);

    //Token
    const TFactory = await hre.ethers.getContractFactory("Token");
    const TcontractAddress = ""; // Replace with your deployed contract address
    const TcontractJS = await SimpleContractFactory.attach(TcontractAddress);   

    //MyNFT
    const NFTFactory = await hre.ethers.getContractFactory("MyNFT");
    const NFTcontractAddress = ""; // Replace with your deployed contract address
    const NFTcontractJS = await SimpleContractFactory.attach(NFTcontractAddress);



  //-------------------------Empieza la interaccion------------
  // Ejemplo Basico dado por el profe
  //obtener data de los cntratos
	const data = await contractJS.getData();
	
  //Empieza interaccion ocn el contrato
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