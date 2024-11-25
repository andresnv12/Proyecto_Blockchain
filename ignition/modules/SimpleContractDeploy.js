const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const simpleContractModule = buildModule("simpleContractModule", (m) => {

//Ejemplo
// Desplegar MainContract utilizando el valor de goal y la dirección de Token
//const mainContract = m.contract("MainContract", [goalValue, tokenContract]);
// Definir el valor de _goal
const goalValue = 10000; // Reemplaza este valor según tus necesidades
const nftsContract = m.contract("MyNFT");
const tokenContract = m.contract("Token");
const crowdfundingContract = m.contract("CrowdFunding",[goalValue,tokenContract,nftsContract]); // rellenamos el constructor

//deploy de los 3 contratos a la vez
 return { nftsContract, tokenContract,crowdfundingContract};

});
module.exports = simpleContractModule;
                                        