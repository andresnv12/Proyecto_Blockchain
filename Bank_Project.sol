// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

contract Bank {

    address banker;

    struct Transaction {
        uint amount;
        uint timeStamp;
    }

    struct Customer {
        Transaction [] paymentReceived;
        Transaction [] paymentSent;
        mapping (address => bool) authorizedUsers;
        uint32 customerBalance;        

    }

    uint totalBalance;
    mapping (address => Customer) bankLedger;

    constructor () {
        banker=msg.sender;
        bankLedger[banker].authorizedUsers[msg.sender]=true;
        totalBalance=0;
    }

    
    function deposit () public payable {
    

    }

    function withdraw (address payable _recipient, uint _amount) public payable returns (bool) {
    
    
    }

    function getCustomerBalance (address _customerAddress) public view returns (uint) {
        
        return bankLedger[_customerAddress].customerBalance;

    }

    function getBankBalance () public view returns (uint) {
        
    
    }

    function addAuthorizedUser  (address _customerAddress, address _addressToAdd) public  {
        require (banker==msg.sender, "Just the bankers can add users");
        
        //_addressToAdd para añadir nuevas cuentas y _customerAddress para cuentas dentro de authorizedUsers
        bankLedger[_addressToAdd].authorizedUsers[_customerAddress] = true; 
        
    }

    function isAuthorizedUser (address _address) public view returns (bool) {
        return bankLedger[_address].authorizedUsers[msg.sender];
    }

    
}

