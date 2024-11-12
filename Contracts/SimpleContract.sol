// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

contract SimpleContract {
    uint public data;

    constructor ()
    {
        data=2024;
        
    }

    function accumulateData (uint _data) public 
    {
        data=data + _data;

    }

    function getData () public view returns (uint)
    {
        return data;

    }

}