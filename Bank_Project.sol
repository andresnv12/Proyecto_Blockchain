// SPDX-License-Identifier: MIT

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
        totalBalance=0;
    }

    
    function deposit () public payable {
    

    }

    function withdraw (address payable _recipient, uint _amount) public payable returns (bool) {
    
    
    }

    function getCustomerBalance () public view returns (uint) {

    

    }

    function getBankBalance () public view returns (uint) {
        
    
    }

    function addAuthorizedUser  (address _customerAddress, address _addressToAdd) public  {
    

    }

    function isAuthorizedUser (address _address) public view returns (bool) {
    
    }

    
}

