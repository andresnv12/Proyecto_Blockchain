// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

//incluir librerias de ERC20
//incluir librerias de ERC721 (NFTs)

contract SimpleContract {
    
    //
    struct Inversor1 {
        int256 moneyInvested;
        int256 tokenX; //cantidad de tokens enviados
    }

    struct Inversor2 {
        int256 moneyInvested;
        int256 tokenY; //cantidad de tokens enviados
        int256 NFTs;
    }
    
    int256 totalFunds;
    address Fundraiser;
    int256 investors;

    //set when the contract was deployed
    constructor ()
    {
        Fundraiser = msg.sender;
        totalFunds = 0;
        investors = 0;
    }

    mapping (address => Inversor1) Backer1;
    mapping (address => Inversor2) Backer2;



    // recordar actualizar los estados de los mappings de acuerdo
    // a como se van generando tokens , NFTs ec
    //funcion que haga relacion dependiendo de cuanto ingresen, se les dara cierta cantidad de tokens
    //funcion para mintear tokens y depositar a los inversones
    //funcion para generar NFTs y agregar al usuario
    //funcion para retirar tanto NFTs como tokens a la direccion de cada usuario


}