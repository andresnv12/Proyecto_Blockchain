// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0

//hacemos el deploy
//subimos el nft a ipfs con filebase, primero creamos un bucket y luego subimos la imagen
// luego subimos los metadatos
// copiamos el CID
//copiamos en funcion del safemint en uri "ipfs://<CID>" en nfts.sol

pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    constructor()
        ERC721("MyNFT", "MTK")
        Ownable(msg.sender)
    {}


    //en esta funcion tenemos que poner el ipfs://<CID del NFT> cuando la llamemos al otro contrato
    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
