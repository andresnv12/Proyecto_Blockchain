// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

//incluir librerias de ERC20
import "./token.sol";
//incluir librerias de ERC721 (NFTs)

contract SimpleContract is Token {
    
    
    struct Inversor1 {
        uint256 moneyInvested; // cantidad de dinero invertido
        uint256 tokenX; //cantidad de tokens enviados
    }

    struct Inversor2 {
        uint256 moneyInvested; //cantidad de dinero invertido
        uint256 tokenY; //cantidad de tokens enviados
        uint256 NFTs;
    }
    
    uint256 totalFunds; //fondos recaudados
    address Fundraiser; //recaudador
    uint256 investors; //inversores
    uint256 private tokens;
    Token public token;
    uint256 goal; // objetivo

    //set when the contract was deployed
    constructor (uint256 _goal,address _tokenAddress)
    {
        token = Token(payable(_tokenAddress));
        Fundraiser = msg.sender;
        totalFunds = 0;
        investors = 0;
        goal = _goal;
    }

    mapping (address => Inversor1) Backer1;
    mapping (address => Inversor2) Backer2;


    function deposit(uint256 _amount) public {
        //mayor a 10000 inverso2
        
        if (_amount >= 10000) {
            //agregar al tracking de cada usuario
            Backer2[msg.sender].moneyInvested += _amount;
            Backer2[msg.sender].tokenY += numberOfTokens(_amount);
            Backer2[msg.sender].NFTs += 1;
            totalFunds += _amount;
            investors += 1;
        }else {
            Backer1[msg.sender].moneyInvested += _amount;
            Backer1[msg.sender].tokenX += numberOfTokens(_amount);
            totalFunds += _amount;
            investors += 1;
        }
    }

    //funcion que nos dice la cantidad de tokens a dar segun el monto
    function numberOfTokens(uint256 _amount) private  returns (uint256){
        tokens = _amount/10;
        return tokens;

    }

    // el contrato puede recibir ether
    receive() external payable {
    }

    
    // recordar actualizar los estados de los mappings de acuerdo
    // a como se van generando tokens , NFTs ec
    //funcion que haga relacion dependiendo de cuanto ingresen, se les dara cierta cantidad de tokens
    //funcion para mintear tokens y depositar a los inversones
    //funcion para generar NFTs y agregar al usuario
    //funcion para retirar tanto NFTs como tokens a la direccion de cada usuario
    //funcion para que el dueno pueda retirar los fondos


}