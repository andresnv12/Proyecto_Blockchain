const hre = require("hardhat");
const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin, 
  output: process.stdout, 
});

let CFcontractJS;
let TcontractJS;
let NFTcontractJS;

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

  const withdraw = await CFcontractJS.withdrawn(investor);
  withdraw.wait(1);

}
function menu() {
  const mostrarMenu = () => {
      console.log("\nMenú Principal:");
      console.log("1. Ingresar inversor");
      console.log("2. Retiro de tokens");
      console.log("3. Salir");
      rl.question("Ingrese una opción: ", (opcion) => {
          switch (opcion) {
              case "1":
                  console.log("Opción 1: Ingresar inversor seleccionada.");
                  Deposit();
                  return mostrarMenu();
              case "2":
                  console.log("Opción 2: Retiro de tokens seleccionada.");
                  Withdraw();
                  return mostrarMenu();
              case "3":
                  console.log("Saliendo del programa...");
                  rl.close();
                  break;
              default:
                  console.log("Opción no válida. Inténtalo de nuevo.");
                  return mostrarMenu();
          }
      });
  };

  mostrarMenu();
}


async function main() {

  try {
  

    //CrowdFunding 
    const CFFactory = await hre.ethers.getContractFactory("CrowdFunding");
    const CFcontractAddress = "0x735D2699a6A2fE63FC6381e0c04A0F6D3cf81D19"; // Replace with your deployed contract address
    const CFcontractJS = await CFFactory.attach(CFcontractAddress);

    //Token
    const TFactory = await hre.ethers.getContractFactory("Token");
    const TcontractAddress = "0x71e9d321E930Cccb50c0501b324768af53401536"; // Replace with your deployed contract address
    const TcontractJS = await TFactory.attach(TcontractAddress);   

    //MyNFT
    const NFTFactory = await hre.ethers.getContractFactory("MyNFT");
    const NFTcontractAddress = "0x6B0659285e7A534349943a11a358F8162219B50D"; // Replace with your deployed contract address
    const NFTcontractJS = await NFTFactory.attach(NFTcontractAddress);



  //-------------------------Empieza la interaccion------------
  

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





   
    
    
  
  
main();