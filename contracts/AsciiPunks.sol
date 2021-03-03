pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AsciiPunks is ERC721 {
  constructor() ERC721("AsciiPunks", "ASC") public {
  }
}
