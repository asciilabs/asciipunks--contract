// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AsciiPunks is ERC721 {
  event Generated(uint indexed index, address indexed a, string value);

  uint public constant TOKEN_LIMIT = 1024;

  constructor() ERC721("AsciiPunks", "ASC") {
  }

  function createPunk() external payable {
    // require(msg.value == (totalSupply() * 1 finney) + 50 finney);
    // require(totalSupply() <= tokenLimit, "AsciiPunks sale has completed.");

    // address(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3).transfer(msg.value/5*4);
    // address(0x027Fb48bC4e3999DCF88690aEbEBCC3D1748A0Eb).transfer(msg.value/5);

    // string memory baseFace = unicode"            \n            \n   ┌────┐   \n   │    ├┐  \n   │   └│  \n   │    └┘  \n   │    │   \n   │    │   \n   │    │   \n   └──┘ │   \n     │  │   \n     │  │   \n";

    // string[155] memory base = [
    //   " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "\n",
    //   " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "\n",
    //   " ", " ", " ", "┌", "─", "─", "─", "─", "┐", " ", " ", " ", "\n",
    //   " ", " ", " ", "│", " ", " ", " ", " ", "├", "┐", " ", " ", "\n",
    //   " ", " ", " ", "│", " ", " ", " ", " ", "└", "│", " ", " ", "\n",
    //   " ", " ", " ", "│", " ", " ", " ", " ", "└", "┘", " ", " ", "\n",
    //   " ", " ", " ", "│", " ", " ", " ", " ", "│", " ", " ", " ", "\n",
    //   " ", " ", " ", "│", " ", " ", " ", " ", "│", " ", " ", " ", "\n",
    //   " ", " ", " ", "│", " ", " ", " ", " ", "│", " ", " ", " ", "\n",
    //   " ", " ", " ", "└", "─", "─", "┘", " ", "│", " ", " ", " ", "\n",
    //   " ", " ", " ", " ", " ", "│", " ", " ", "│", " ", " ", " ", "\n",
    //   " ", " ", " ", " ", " ", "│", " ", " ", "│", " ", " ", " "
    // ]

    string memory base = unicode"            \n            \n   ┌────┐   \n   │    ├┐  \n   │    └│  \n   │    └┘  \n   │    │   \n   │    │   \n   │    │   \n   └──┘ │   \n     │  │   \n     │  │   ";

    base[1];

    // string memory punk = new string(155);

    // for (var i = 0; i < 155; i++) {
    //   face[i] = base[i]
    // }

    // bytes memory _bytes = unicode"   ┌────┐   ";



    // string[8] memory leftFaceCharacters = [ "ʕ" , "✿" ,"꒰" , ":" , "{" , "|" , "[" , "(" ];
    // string[13] memory eyeCharacters = ["◕" , "👁" , "ಥ" , "♥" , "ʘ̚", "X", "⊙" , "˘" , "ಠ" , "◉" , "⚆" , "¬" , "^" ];
    // string[11] memory mouthCharacters = [ "ᴥ" , "益" , "෴" , "ʖ" , "ᆺ" , "." , "o", "◡" , "_" , "╭╮" , "‿" ];
    // string[8] memory rightFaceCharacters = [ "ʔ" , "✿" ,"꒱" , ":" , "}" , "|" , "]" , ")" ];

    // uint256 leftFacePartID = getLeftFace(seed + totalSupply());
    // uint256 leftEyePartID = getLeftEye(seed + totalSupply());
    // uint256 mouthPartID = getMouth(seed + totalSupply());
    // uint256 rightEyePartID = getRightEye(seed + totalSupply());
    // uint256 rightFacePartID = getRightFace(seed + totalSupply());

    // string memory faceAssembly = string(abi.encodePacked(leftFaceCharacters[leftFacePartID], eyeCharacters[leftEyePartID], mouthCharacters[mouthPartID], eyeCharacters[rightEyePartID], rightFaceCharacters[rightFacePartID]));
    

    // _registerToken(punk);
  // }

  // function _registerToken(string memory value) private {
  //   uint256 tokenId = totalSupply();

  //   id_to_value[tokenId] = value;
  //   value_to_id[value] = tokenId;


  //   _mint(msg.sender, tokenId);
  }
}
