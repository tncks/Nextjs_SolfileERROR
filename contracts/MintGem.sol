// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MintGEM is ERC721Enumerable, Ownable  {
    string uri;
    
    constructor(string memory _name, string memory _symbol, string memory _uri) ERC721(_name, _symbol) {
        uri = _uri;
    }

    struct GemData {
        uint gemRank;
        uint gemType;
    }

    mapping(uint => GemData) public gemData;

    // 1 klay
    uint gemPrice = 1000000000000000000;

    function tokenURI(uint _tokenId) override public view returns (string memory) {
        string memory gemRank = Strings.toString(gemData[_tokenId].gemRank);
        string memory gemType = Strings.toString(gemData[_tokenId].gemType);

        return string(
            abi.encodePacked(uri, '/', gemRank, '/', gemType, '.json')
        );

        
    }

    function mintGem() public payable {
        require(gemPrice <= msg.value, "Not enough Klay.");
        uint tokenId = totalSupply() + 1;

        uint randomNonce = tokenId;


        uint randomRank = uint(keccak256(abi.encodePacked(blockhash(block.timestamp), msg.sender, randomNonce))) % 10;
        randomNonce++;
        

        uint gemRank;
        uint gemType;

        if(randomRank == 0){
            gemRank = 4;
        } else {
            if(randomRank % 3 == 0) {
                gemRank = 2;
            } else if(randomRank % 4 == 0){
                gemRank = 3;
            } else {
                gemRank = 1;
            }
        }

        gemType = uint(keccak256(abi.encodePacked(blockhash(block.timestamp), msg.sender, randomNonce))) % 4 + 1;


        payable(owner()).transfer(msg.value);

        gemData[tokenId] = GemData(gemRank, gemType);
        
        _mint(msg.sender, tokenId);

        
    }

	function getLatestMintedGem(address _owner) public view returns (uint, uint) {
		uint balanceLength = balanceOf(_owner);

		uint tokenId = tokenOfOwnerByIndex(_owner, balanceLength -1);

		return (gemData[tokenId].gemRank, gemData[tokenId].gemType);
	}
}