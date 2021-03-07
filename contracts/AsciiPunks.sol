// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Punk.sol";

contract AsciiPunks is ERC721 {
  event Generated(uint indexed index, address indexed a, string value);

  event Debug(string value);

  uint public constant TOKEN_LIMIT = 1024;

  uint internal constant ROW_LENGTH = 12;
  uint internal constant ROW_COUNT = 12;

  constructor() ERC721("AsciiPunks", "ASC") {
  }

  function splice(
    string[ROW_LENGTH * ROW_COUNT] memory rows,
    string[ROW_COUNT] memory newRow,
    uint rowNum
  ) internal pure returns (string[ROW_LENGTH * ROW_COUNT] memory) {
    for (uint i = 0; i < ROW_LENGTH; i++) {
      rows[(rowNum * ROW_LENGTH) + i] = newRow[i];
    }

    return rows;
  }

  function createPunk() external payable {
    // require(msg.value == (totalSupply() * 1 finney) + 50 finney);

    // require(totalSupply() <= TOKEN_LIMIT, "AsciiPunks sale has completed.");


    Punk punk = new Punk();
    punk.drawPunk();
    // _registerToken(punk);
  }

  // function _registerToken(string memory value) private {
  //   uint256 tokenId = totalSupply();

  //   id_to_value[tokenId] = value;
  //   value_to_id[value] = tokenId;


  //   _mint(msg.sender, tokenId);
  // }
}
