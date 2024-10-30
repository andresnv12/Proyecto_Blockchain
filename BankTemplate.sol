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
        mapping (address => bool) authorizedUsers; 
        uint256 customerBalance;        

    }

    struct autorizados{
        address customer;
        bool set;
    }
    uint totalBalance;
    //tipo direccion cliente
    //direccion :: cliente
    mapping (address => Customer) bankLedger;
    mapping (address => autorizados) authorizedUsers;

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

    // @Chris Done
    // @Chris usuario  autorizado solo puede tener un customer asignado, asi no usamos el customer directmente
    function withdraw (address payable _recipient, uint _amount) public payable returns (bool) {
        //ocupamos el address del customer , y ademas el msg.sender debe de estar autorizado
        require(isAuthorizedUser(authorizedUsers[msg.sender].customer,msg.sender),"no estas autorizado por el customer");


        //1-ademas agregar un require que nos diga si tiene suficiente dinero para hacer el retiro
        require(bankLedger[authorizedUsers[msg.sender].customer].customerBalance >= _amount,"no hay dinero suficiente para realizar la transferencia");
        //1-bajamos el _amount del balance del cliente 
        bankLedger[authorizedUsers[msg.sender].customer].customerBalance -= _amount;
        //ahora si lo enviamos a la direccion 
        bool operationExecuted=_recipient.send(_amount);
        require (operationExecuted, "The balance could not be withdrawn");
        totalBalance = totalBalance - _amount;
        bankLedger[authorizedUsers[msg.sender].customer].paymentSent.push(Transaction({amount:_amount,timeStamp: block.timestamp}));
        return true;
    }

    // @chris aqui aun puedo volarme el _customer pero podemos hablalro
    function isAuthorizedUser (address _customer, address _address) public view returns (bool) {
        //yo como customer puedo revisar si cierto address lo tengo como como autorizado
        return bankLedger[_customer].authorizedUsers[_address];
    }

    //ready
    function getCustomerBalance () public view returns (uint) {
        
        return bankLedger[msg.sender].customerBalance;


    }
    //ready
    function getBankBalance () public view returns (uint) {
        require(msg.sender == banker, "Solo el owner del banco puede saber esta informacion" );
        return address(this).balance;
    }

    //ready
    function addAuthorizedUser  (address _customerAddress, address _addressToAdd) public  {
    //agregar usuarios al mapping
    require(msg.sender == _customerAddress, "Solo el cliente puede agregar mas autorizados");
    require(!authorizedUsers[_addressToAdd].set,"ya el usuario esta como autorizado");
    bankLedger[_customerAddress].authorizedUsers[_addressToAdd] = true;
    authorizedUsers[_addressToAdd].customer = _customerAddress;
    authorizedUsers[_addressToAdd].set = true;
    }

    // podemos agregar unas funciones que sigan las transaccion de cada customer para poder , puede ser como eventos
}

