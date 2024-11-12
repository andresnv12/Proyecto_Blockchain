// SPDX-License-Identifier: GPL-3.0

//Christophe
//Andres
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

    
    
    uint totalBalance;
    mapping (address => Customer) bankLedger;
    
    // @Chris mapping para saber a que customer esta autorizado es direccion
    // @Chris cada address solo puede estar auotirzado a un customer especifico
    mapping (address => autorizados) authorizedUsers;
    
    // @Chris Switch between customer or authorized user
    bool customerState = true;

    constructor () {
        banker=msg.sender;
        totalBalance=0;
    }
    
    
    //Deposit Function
    function deposit () public payable {
        //update the total balance
        totalBalance = totalBalance + msg.value;
        //add the deposit in the customer account
        bankLedger[msg.sender].customerBalance += msg.value;
        //bankledger for banker and customer
        bankLedger[msg.sender].paymentReceived.push(Transaction({amount:msg.value,timeStamp: block.timestamp, status: "Recibido"}));
        bankLedger[msg.sender].allPayments.push(Transaction({amount:msg.value,timeStamp: block.timestamp, status: "Recibido"}));
    
    }

    function withdraw (address payable _recipient, uint _amount) public payable returns (bool) {
        
        
        //like authorized user
        if (customerState == false){


            require(isAuthorizedUser(authorizedUsers[msg.sender].customer, msg.sender),"No estas autorizado para realizar la operacion");
            //require for sure the customer has sufficiente money in your account
            require(bankLedger[authorizedUsers[msg.sender].customer].customerBalance >= _amount,"no hay dinero suficiente para realizar la transferencia");
            //al cliente le quitamos ese dinero
            bankLedger[authorizedUsers[msg.sender].customer].customerBalance -= _amount;
            //lo enviamos a la direccion
            bool operationExecuted=_recipient.send(_amount);
            //verificamos que la transaccion se haya echo
            require (operationExecuted, "The balance could not be withdrawn");

            totalBalance = totalBalance - _amount;

            //registramos las transacciones
            bankLedger[authorizedUsers[msg.sender].customer].paymentSent.push(Transaction({amount:_amount,timeStamp: block.timestamp, status: "Enviado"}));
            bankLedger[authorizedUsers[msg.sender].customer].allPayments.push(Transaction({amount:_amount,timeStamp: block.timestamp, status: "Enviado"}));
            return true;
        }

        //like Customer user
        else {
            //1-ademas agregar un require que nos diga si tiene suficiente dinero para hacer el retiro
            require(bankLedger[msg.sender].customerBalance >= _amount,"no hay dinero suficiente para realizar la transferencia");
            //1-bajamos el _amount del balance del cliente 
            bankLedger[msg.sender].customerBalance -= _amount;
            //ahora si lo enviamos a la direccion 
            bool operationExecuted=_recipient.send(_amount);
            require (operationExecuted, "The balance could not be withdrawn");
            totalBalance = totalBalance - _amount;
            bankLedger[msg.sender].paymentSent.push(Transaction({amount:_amount,timeStamp: block.timestamp, status: "Enviado"}));
            bankLedger[msg.sender].allPayments.push(Transaction({amount:_amount,timeStamp: block.timestamp, status: "Enviado"}));
            return true;
        }

        return false;

    }
    // only de customer balance can see your balance
    function getCustomerBalance () public view returns (uint) {
        
        return bankLedger[msg.sender].customerBalance;

    }

    // only the banker can see your your balance
    function getBankBalance () public view returns (uint) {
        require(msg.sender == banker, "Solo el owner del banco puede saber esta informacion" );
        return address(this).balance;
    
    }


    function addAuthorizedUser  (address _customerAddress, address _addressToAdd) public  {
        //solo el customer puede agregar mas usuarios autorizados
        require (msg.sender == _customerAddress, "Just the bankers can add users");
        //agregar usuarios al mapping
        require(!authorizedUsers[_addressToAdd].set,"ya el usuario esta como autorizado");

        //_addressToAdd para añadir nuevas cuentas y _customerAddress para cuentas dentro de authorizedUsers
        bankLedger[_customerAddress].authorizedUsers[_addressToAdd] = true; 
        authorizedUsers[_addressToAdd].customer = _customerAddress;
        authorizedUsers[_addressToAdd].set = true;
        //bankLedger[_customerAddress].authorizedUsers[_customerAddress]=true;
    }

    function isAuthorizedUser (address _customer, address _address) public view returns (bool) {
        //yo como customer puedo revisar si cierto address lo tengo como como autorizado
        return bankLedger[_customer].authorizedUsers[_address];
    }

    //obtener lista de transacciones customer
    function getTransactionHistoryCustomer () public view returns (Transaction[] memory) {

        
        return bankLedger[msg.sender].allPayments;

    }
    
    //activar como Customer
    function activeCustomer() public {
        customerState = true;
    }

    //Activar como autorizado
    function deactiveCustomer() public {
        customerState = false;
    }

}