// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Bank {

    address banker;

    struct Transaction {
        uint amount;
        uint timeStamp;
    }


    // es un cliente que tiene autorizados a otras personas para realizar ciertos pagos ...
    struct Customer {
        Transaction [] paymentReceived;
        Transaction [] paymentSent;
        mapping (address => bool) authorizedUsers; //usuarios registrados como clientes
        uint256 customerBalance;        

    }

    uint totalBalance;
    //tipo direccion cliente
    //direccion :: cliente
    mapping (address => Customer) bankLedger;

    constructor () {
        //inicializa el banco cuando hace deploy
        banker=msg.sender;
        totalBalance=0;
    }

    // @Chris Funcion lista
    function deposit () public payable {
        totalBalance = totalBalance + msg.value;
        bankLedger[msg.sender].customerBalance += msg.value;
        //libro de transacciones,esto admite directamente , solo bloques de tipo transaction
        bankLedger[msg.sender].paymentReceived.push(Transaction({amount:msg.value,timeStamp: block.timestamp}));

    }

    // @Chris WIP
    function withdraw (address payable _recipient, uint _amount, address _customer) public payable returns (bool) {
        //ocupamos el address del customer , y ademas el msg.sender debe de estar autorizado
        require(isAuthorizedUser(_customer,msg.sender),"no estas autorizado por el customer");


        //1-ademas agregar un require que nos diga si tiene suficiente dinero para hacer el retiro
        require(bankLedger[_customer].customerBalance >= _amount,"no hay dinero suficiente para realizar la transferencia");
        //1-bajamos el _amount del balance del cliente 
        bankLedger[_customer].customerBalance -= _amount;
        //ahora si lo enviamos a la direccion 
        bool operationExecuted=_recipient.send(_amount);
        require (operationExecuted, "The balance could not be withdrawn");
        totalBalance = totalBalance - _amount;
        bankLedger[_customer].paymentSent.push(Transaction({amount:msg.value,timeStamp: block.timestamp}));
        return true;
    }

    function isAuthorizedUser (address _address, address _customer) public view returns (bool) {
        //yo como customer puedo revisar si cierto address lo tengo como como autorizado
        return bankLedger[_customer].authorizedUsers[_address];
    }


    function getCustomerBalance () public view returns (uint) {
        
        return bankLedger[msg.sender].customerBalance;


    }

    function getBankBalance () public view returns (uint) {
        require(msg.sender == banker, "Solo el owner del banco puede saber esta informacion" );
        return address(this).balance;
    }

    //ready
    function addAuthorizedUser  (address _customerAddress, address _addressToAdd) public  {
    //agregar usuarios al mapping
    require(msg.sender == _customerAddress, "Solo el cliente puede agregar mas autorizados");
    require(!bankLedger[_customerAddress].authorizedUsers[_addressToAdd],"ya el usuario esta como autorizado");
    bankLedger[_customerAddress].authorizedUsers[_addressToAdd] = true;
    }    
}

