const hre = require("hardhat");
const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin, 
  output: process.stdout, 
});

let CFcontractJS;
let TcontractJS;
let NFTcontractJS;
let amount;
let investor;

async function Deposit() {

  rl.question("Please deposit an amount: ", async (input) => {
    amount = parseInt(input);
    rl.close();
  });

  rl.question("Please add the investor address: ", async (input) => {
    investor = input;
    rl.close();
  });

  const deposit = await CFcontractJS.deposit(amount, investor);
  await deposit.wait(1);
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
    const CFcontractAddress = "0x06002AE5ee433980bd268Ff11d48B83E01014eFA"; // Replace with your deployed contract address
    const CFcontractJS = await CFFactory.attach(CFcontractAddress);

    //Token
    const TFactory = await hre.ethers.getContractFactory("Token");
    const TcontractAddress = "0xFB5714584d281e4F9b6d8546A123db8797b89ab5"; // Replace with your deployed contract address
    const TcontractJS = await TFactory.attach(TcontractAddress);   

    //MyNFT
    const NFTFactory = await hre.ethers.getContractFactory("MyNFT");
    const NFTcontractAddress = "0x318c7bE5e0ad7789DcE3Ec17493486aD4FE13c7E"; // Replace with your deployed contract address
    const NFTcontractJS = await NFTFactory.attach(NFTcontractAddress);

    //const NFT_approve = await NFTcontractJS.transferOwnership(CFcontractAddress);
    //NFT_approve.wait(1);



  //-------------------------Empieza la interaccion------------
  

    console.log("Approving the CrowdFunding contract inside the token contract...");
    const approve = await TcontractJS.approve(CFcontractAddress, 10000000);
    await approve.wait(1);
    console.log("Approve....");


    ///////////TESTING/////////
    //let inversor = "0x10EF23fe0763CB493eC434C488a4B0F28Ac0bd83";//yo mismo
    ////let inversor = "0x6fC39e794AfEA7A4506D697514aeB47C4eE5df19";
    //let uri = "ipfs://QmTN3norZ3PQAcvew69xPLrXa9VixM5H9BYunkDbEJA1i4";
    ////deposit
    //console.log("Deposit function....");
    //const deposit = await CFcontractJS.deposit(11000, inversor);
    //console.log("Transaction hash:  ", deposit.hash)
    //console.log("End Deposit function....");
    //await deposit.wait(1);
    //menu();
//
    ////withdraw
    //console.log("Withdraw function....");
    //const withdraw = await CFcontractJS.withdrawn(inversor,uri);
    //console.log("Transaction hash:  ", withdraw.hash)
    //console.log("End withdraw function..");
    //await withdraw.wait(1);

  ///////////TESTING/////////


  
  
  }

  catch (error) {

   console.error(error);

   process.exit(1);

 }
}





   
    
    
  
  
main();