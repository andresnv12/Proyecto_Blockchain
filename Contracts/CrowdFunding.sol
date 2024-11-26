// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

//incluir librerias de ERC20
import "./token.sol";
//incluir librerias de ERC721 (NFTs)
import "./MyNFT.sol";

contract CrowdFunding is Token {
    
    
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
    MyNFT public nft;
    uint256 goal; // objetivo
    uint256 temp;
    uint256 tempNFTs;
    //set when the contract was deployed
    constructor (uint256 _goal,address _tokenAddress, address _NftAddress)
    {
        token = Token(payable(_tokenAddress));
        nft = MyNFT(_NftAddress);
        //inicializar NFT AQUI
        Fundraiser = msg.sender;
        totalFunds = 0;
        investors = 0;
        goal = _goal;
    }

    mapping (address => Inversor1) Backer1;
    mapping (address => Inversor2) Backer2;

    function deposit(uint256 _amount, address inversor) public {
        require(msg.sender == Fundraiser, "Solo el Owner puede hacer agregar inversores en este contrato");
        //mayor a 10000 inverso2
        
        if (_amount >= 10000) {
            //agregar al tracking de cada usuario
            Backer2[inversor].moneyInvested += _amount;
            Backer2[inversor].tokenY += numberOfTokens(_amount);
            Backer2[inversor].NFTs += 1;
            totalFunds += _amount;
            investors += 1;
        }else {
            Backer1[inversor].moneyInvested += _amount;
            Backer1[inversor].tokenX += numberOfTokens(_amount);
            totalFunds += _amount;
            investors += 1;
        }
    }

    
    //funcion que nos dice la cantidad de tokens a dar segun el monto
    function numberOfTokens(uint256 _amount) private  returns (uint256){
        tokens = _amount/10;
        return tokens;
    }


    function withdrawn(address inversor) public {
        //ocupo pasarle esa cantidad de tokens al contrato de crownfunding
        require(msg.sender == Fundraiser, "Solo el Owner puede hacer retiros en este contrato");
        //revisar funciones
        if (Backer1[inversor].tokenX > 0) {
            //se almacena en temp la cantidad de tokens a enviar
            temp = Backer1[inversor].tokenX;
            Backer1[inversor].tokenX = 0;
            token.transferFrom(Fundraiser, inversor, temp * 100); // por los decimales del token
            temp = 0;
        }else {
            temp = Backer2[inversor].tokenY;
            Backer2[inversor].tokenY = 0;
            tempNFTs = Backer2[inversor].NFTs;
            Backer2[inversor].NFTs = 0;
            //Send tokens
            token.transferFrom(Fundraiser, inversor, temp * 100); // por los decimales del token
            temp = 0;
            //Send NFTs 
            nft.safeMint(inversor, "ipfs://QmNQFmnBP1YdjMWQsRHNRVGBq9YjPVFmDJY93qKWFQNYa6");

        }
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