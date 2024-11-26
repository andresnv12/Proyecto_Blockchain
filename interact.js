const hre = require("hardhat");
const readline = require("readline");

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
  
    const rl = readline.createInterface({
      input: process.stdin, 
      output: process.stdout, 
    });

    console.log("Approving the CrowdFunding contract inside the token contract...");
    const approve = await TcontractJS.approve(CFcontractAddress, 10000000);
    approve.wait(1);
    menu();

  }

  catch (error) {

   console.error(error);

   process.exit(1);

 }
}

async function Deposit() {

  rl.question("Please deposit an amount: ", async (input) => {
    const amount = parseInt(input);
    rl.close();
  });

  rl.question("Please add the investor address: ", async (input) => {
    const investor = input;
    rl.close();
  });

const deposit = await CFcontractJS.deposit(amount, investor);
deposit.wait(1);
}

async function Withdraw() {

  rl.question("Please add the investor address: ", async (input) => {
    const investor = input;
    rl.close();
  });

  const withdraw = await CFcontractJS.withdraw(investor);
  withdraw.wait(1);

}

const readline = require("readline-sync");

function menu() {
    let opcion;

    do {
        // Mostrar el menú
        console.log("\nMenú Principal:");
        console.log("1. Ingresar inversor");
        console.log("2. Retiro de tokens");
        console.log("3. Salir");
        opcion = readline.question("Ingrese una opción: ");

        
        switch (opcion) {
            case "1":
                Deposit();
                break;
            case "2":
                Withdraw();
                break;
            case "3":
                console.log("Saliendo del programa...");
                break;
            default:
                console.log("Opción no válida. Inténtelo de nuevo.");
        }
    } while (opcion !== "3");
}

   
    
    
  
  
main();