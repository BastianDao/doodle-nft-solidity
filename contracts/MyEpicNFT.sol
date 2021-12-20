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

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: #01B4C6; font-family: sans-serif; font-size: 24px; font-weight:700;}</style><rect width='100%' height='100%' fill='#BEE5FD' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ['Big', 'Crazy', 'Slow', 'Supreme', 'Retired', 'Ace', 'Big', 'High', 'Giant', 'Little', 'Old', 'Super', 'Supreme'];
    string[] secondWords = ['Adjucator', 'Afro', 'Alien', 'Antenna', 'Aqua', 'Bald', 'Barber', 'Beard', 'Fat', 'Mechanical', 'Wasp', 'Evil', 'Careless', 'Cat', 
    'Commander', 'Completionist', 'Cool', 'Cop', 'Cronenberg', 'Curly-haired', 'Cyclops', 'Dandy', 'Doofus', 'Dreamy', 'Dumb', 'Earring', 'EyePatch', 'Fancy', 
    'Farmer', 'Fascist', 'Pickle', 'Grandpa', 'Grateful', 'Guard', 'Guilty', 'Happy', 'Hologram', 'Hawaiian', 'Headband', 'Hopeful', 'Hothead', 'Insurance', 
    'Investigator', 'John', 'Josuke', 'Juggling', 'JunkYard', 'Lizard', 'Maximums', 'Memory', 'Miami', 'Mysterious', 'Nega', 'Novelist', 'God', 'Plumber', 
    'Quantum', 'Radar', 'Revengeful', 'Robot', 'Salesman', 'Policitian', 'Shibuya', 'Shrimp', 'Simple', 'Jamz', 'Solicitor', 'Fan', 'Survivor', 'Weird', 
    'Teddy', 'Tiny', 'Toxic', 'Visor', 'Western', 'Yo-Yo', 'Zero'];
    string[] thirdWords = ['Rick', 'Morty', 'Jerry', 'Beth', 'Summers', 'Mr.Poopybutthole', 'Birdperson'];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721 ("Rick & Morty NFT", "RICKMORTY") {
        console.log("NFT FTW!");
        totalNFT = 50;
    }

    function random (string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_wORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256) {
        console.log(_tokenIds.current());
        return _tokenIds.current();
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        require(newItemId < totalNFT);

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A collection of Rick & Morty (potential) character names.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
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

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        console.log("%s minted by %s", newItemId, msg.sender);
        _tokenIds.increment();

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}