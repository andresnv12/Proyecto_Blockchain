// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

contract Bank {

    address banker;

    struct Transaction {
        uint amount;
        uint timeStamp;
        string status;
    }

    struct Customer {
        Transaction [] paymentReceived;
        Transaction [] paymentSent;
        Transaction [] allPayments;
        mapping (address => bool) authorizedUsers;
        uint256 customerBalance;        

    }

    struct autorizados{
        address customer;
        bool set;
    }

    
    Transaction [] public transactions;
    uint totalBalance;
    mapping (address => Customer) bankLedger;
    mapping (address => autorizados) authorizedUsers;
    int counter;
    constructor () {
        banker=msg.sender;
        totalBalance=0;
    }
    //
    
    function deposit () public payable {
        totalBalance = totalBalance + msg.value;
        bankLedger[msg.sender].customerBalance += msg.value;
        //libro de transacciones,esto admite directamente , solo bloques de tipo transaction
        bankLedger[msg.sender].paymentReceived.push(Transaction({amount:msg.value,timeStamp: block.timestamp, status: "Recibido"}));
        bankLedger[msg.sender].allPayments.push(Transaction({amount:msg.value,timeStamp: block.timestamp, status: "Recibido"}));
    
    }

    function withdraw (address _customerAccount, address payable _recipient, uint _amount) public payable returns (bool) {
         //ocupamos el address del customer , y ademas el msg.sender debe de estar autorizado
        
        //require(isAuthorizedUser(authorizedUsers[msg.sender].customer, msg.sender),"No estas autorizado para realizar la operacion");
        require(
            msg.sender == _customerAccount || 
            isAuthorizedUser(_customerAccount, msg.sender),
            "No estas autorizado para realizar la operacion"
        );
        //1-ademas agregar un require que nos diga si tiene suficiente dinero para hacer el retiro
        // require(bankLedger[authorizedUsers[msg.sender].customer].customerBalance >= _amount,"no hay dinero suficiente para realizar la transferencia");
        // //1-bajamos el _amount del balance del cliente 
        // bankLedger[authorizedUsers[msg.sender].customer].customerBalance -= _amount;

        require(
            bankLedger[_customerAccount].customerBalance >= _amount,
            "No hay dinero suficiente para realizar la transferencia"
        );

        bankLedger[_customerAccount].customerBalance -= _amount;
        //ahora si lo enviamos a la direccion 
        bool operationExecuted=_recipient.send(_amount);
        require (operationExecuted, "The balance could not be withdrawn");
        totalBalance = totalBalance - _amount;
        bankLedger[authorizedUsers[msg.sender].customer].paymentSent.push(Transaction({amount:_amount,timeStamp: block.timestamp, status: "Enviado"}));
        bankLedger[authorizedUsers[msg.sender].customer].allPayments.push(Transaction({amount:_amount,timeStamp: block.timestamp, status: "Enviado"}));
        return true;
       

    }

    function getCustomerBalance () public view returns (uint) {
        
        return bankLedger[msg.sender].customerBalance;

    }

    function getBankBalance () public view returns (uint) {
        require(msg.sender == banker, "Solo el owner del banco puede saber esta informacion" );
        return address(this).balance;
    
    }

    function addAuthorizedUser  (address _customerAddress, address _addressToAdd) public  {
        require (msg.sender == _customerAddress, "Just the bankers can add users");
        //agregar usuarios al mapping
        require(!authorizedUsers[_addressToAdd].set,"ya el usuario esta como autorizado");

        //_addressToAdd para añadir nuevas cuentas y _customerAddress para cuentas dentro de authorizedUsers
        bankLedger[_customerAddress].authorizedUsers[_addressToAdd] = true; 
        authorizedUsers[_addressToAdd].customer = _customerAddress;
        authorizedUsers[_addressToAdd].set = true;
        bankLedger[_customerAddress].authorizedUsers[_customerAddress]=true;
    }

    function isAuthorizedUser (address _customer, address _address) public view returns (bool) {
        //yo como customer puedo revisar si cierto address lo tengo como como autorizado
        return bankLedger[_customer].authorizedUsers[_address];
    }

    function getTransactionHistoryCustomer () public view returns (Transaction[] memory) {

        
        return bankLedger[msg.sender].allPayments;

    }
    
    
}

