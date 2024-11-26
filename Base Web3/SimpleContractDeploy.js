const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const simpleContractModule = buildModule("simpleContractModule", (m) => {

const simpleContract = m.contract("SimpleContract");

 return { simpleContract };

});
module.exports = simpleContractModule;
                                        