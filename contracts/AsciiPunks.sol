pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AsciiPunks is ERC721 {
  event Generated(uint indexed index, address indexed a, string value);

  uint public constant TOKEN_LIMIT = 512;

  constructor() ERC721("AsciiPunks", "ASC") public {
  }

  function draw(uint id) public view returns (string memory) {
    // string memory baseHead = unicode"            \n            \n   ┌────┐   \n   │    ├┐  \n   │   └│  \n   │    └┘  \n   │    │   \n   │    │   \n   │    │   \n   └──┘ │   \n     │  │   \n     │  │   \n";

    // string memory baseHead = unicode"┌";

    // return baseHead;
    return " ";
  }
}
