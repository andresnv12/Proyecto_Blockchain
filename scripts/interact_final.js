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
const uri = "ipfs://QmTN3norZ3PQAcvew69xPLrXa9VixM5H9BYunkDbEJA1i4";

async function Deposit() {
  rl.question("Please deposit an amount: ", (input) => {
    amount = parseInt(input);

    rl.question("Please add the investor address: ", async (input) => {
      investor = input;

      try {
        if (amount >= 10000) {
            console.log("Eres un inversor de tipo 2 , te daremos tokens y un NFT...\n")
        }
        else{
            console.log("Eres un inversor de tipo 1 , te daremos tokens...\n")
        }
        console.log("Deposit function....");
        const deposit = await CFcontractJS.deposit(amount, investor);
        console.log("Transaction hash for deposit:  ", deposit.hash)
        await deposit.wait(1);
        console.log("Deposit successful! \n");
      } catch (error) {
        console.error("Error during deposit:", error);
      }

      menu();
    });
  });
}

async function Withdraw() {
    rl.question("Please add the investor address: ", async (input) => {
    investor = input;

    try {
      console.log("Withdraw function....");
      const withdraw = await CFcontractJS.withdrawn(investor,uri);
      console.log("Transaction hash for withdraw:  ", withdraw.hash)
      await withdraw.wait(1);
      console.log("Withdraw successful!");
    } catch (error) {
      console.error("Error during withdrawal:", error);
    }

    menu();
  });
}

function menu() {
  console.log("\nMenú Principal:");
  console.log("1. Ingresar inversor");
  console.log("2. Retiro de tokens");
  console.log("3. Salir");

  rl.question("Ingrese una opción: ", (opcion) => {
    switch (opcion) {
      case "1":
        console.log("Opción 1: Ingresar inversor seleccionada.");
        Deposit();
        break;
      case "2":
        console.log("Opción 2: Retiro de tokens seleccionada.");
        Withdraw();
        break;
      case "3":
        console.log("Muchas gracias por su Donacion :)");
        console.log("Recuerda que cada token es canjeable segun su precio por cantidad de millas...")
        rl.close();
        break;
      default:
        console.log("Opción no válida. Inténtalo de nuevo.");
        menu();
    }
  });
}

async function main() {
  try {
    // CrowdFunding
    const CFFactory = await hre.ethers.getContractFactory("CrowdFunding");
    const CFcontractAddress = "0x06002AE5ee433980bd268Ff11d48B83E01014eFA"; 
    CFcontractJS = CFFactory.attach(CFcontractAddress); 

    // Token
    const TFactory = await hre.ethers.getContractFactory("Token");
    const TcontractAddress = "0xFB5714584d281e4F9b6d8546A123db8797b89ab5";
    TcontractJS = TFactory.attach(TcontractAddress); 

    // MyNFT
    const NFTFactory = await hre.ethers.getContractFactory("MyNFT");
    const NFTcontractAddress = "0x318c7bE5e0ad7789DcE3Ec17493486aD4FE13c7E";
    NFTcontractJS = NFTFactory.attach(NFTcontractAddress); 

    console.log("Approving the CrowdFunding contract inside the token contract...");
    const approve = await TcontractJS.approve(CFcontractAddress, 10000000);
    await approve.wait(1);
    console.log("Approve successful!");
    console.log("--------------------");

    menu();
  } catch (error) {
    console.error("Error in main:", error);
    process.exit(1);
  }
}

main();


///////////TESTING/////////
 //deposit
    // console.log("Deposit function....");
    // const deposit = await CFcontractJS.deposit(11000, inversor);
    // console.log("Transaction hash:  ", deposit.hash)
    // console.log("End Deposit function....");
    // await deposit.wait(1);
   
   

    // //withdraw
    // console.log("Withdraw function....");
    // const withdraw = await CFcontractJS.withdrawn(inversor,uri);
    // console.log("Transaction hash:  ", withdraw.hash)
    // console.log("End withdraw function..");
    // await withdraw.wait(1);

  ///////////TESTING/////////