// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./ERC721Tradable.sol";

/**
 * @title provedERC721
 * provedERC721 - a contract for my non-fungible work.
 */
contract Proved is ERC721Tradable {
    mapping(uint256 => string) private _tokenURIMap;
    mapping(uint256 => string) private _tokenHashMap;
    mapping(string => bool) private _hashExistsMap;
    constructor(address _proxyRegistryAddress)
        ERC721Tradable("Proved", "PRV", _proxyRegistryAddress)
    {}

    function baseTokenURI() override public pure returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function contractURI() public pure returns (string memory) {
        return "https://github.com/ProvedNFT/proved-contract";
    }

    function mint(address[] memory _to, string[] memory hashArray, string[] memory uriArray) public onlyOwner {
        require(
            _to.length == hashArray.length && _to.length == uriArray.length ,
            "Proved: the lengths of arguments mismatched"
        );
        require(
            1 <= hashArray.length && hashArray.length <= 200,
            "Proved: out of the quantity range of [1,200]"
        );
        for(uint i = 0; i < hashArray.length; ++i) {
            string memory _hash = hashArray[i];
            require(
                _hashExistsMap[_hash] == false,
                "Proved: duplicate metadata"
            );
            uint256 currentTokenId = mintTo(_to[i]);
            _hashExistsMap[_hash] = true;
            _tokenHashMap[currentTokenId] = _hash;
            _tokenURIMap[currentTokenId] = uriArray[i];
        }
    }

    function tokenURI(uint256 _tokenId) override public view returns (string memory) {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return string(abi.encodePacked(baseTokenURI(), _tokenURIMap[_tokenId]));
    }

    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);
        delete _hashExistsMap[_tokenHashMap[tokenId]];
        delete _tokenHashMap[tokenId];
        delete _tokenURIMap[tokenId];
    }
}