pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from './libraries/Base64.sol';

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint8 totalNFT;

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    struct MetaData {
        uint256 timestamp;
        uint256 tokenID;
        string tokenURI;
    }

    mapping(address => MetaData[]) public userNFTs;

    constructor() ERC721 ("Doodle NFT", "DOODLE") {
        console.log("NFT FTW!");
        totalNFT = 50;
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256) {
        console.log(_tokenIds.current());
        return _tokenIds.current();
    }

    function makeAnEpicNFT(string memory doodle) public {
        uint256 newItemId = _tokenIds.current();

        string memory doodleName = "Doodle NFT"; // Use a fixed name for now

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        doodleName,
                        '", "description": "NFT created with DOODLE NFT.", "image": "',
                        doodle,
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");

        MetaData memory tokenMetaData = MetaData(block.timestamp, newItemId, doodle);
        userNFTs[msg.sender].push(tokenMetaData);
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        console.log("%s minted by %s", newItemId, msg.sender);
        _tokenIds.increment();

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function NFTsMetaDataByOwner(address _nftOwner) external view returns(MetaData[] memory) {
        return userNFTs[_nftOwner];
    }
}