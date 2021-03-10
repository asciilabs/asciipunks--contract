// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Punk.sol";

contract AsciiPunks is ERC721 {
  uint public constant TOKEN_LIMIT = 512;
  bool public hasSaleStarted = false;

  uint private constant PRICE = 300000000000000000;

  // event Generated(uint indexed index, address indexed a, string value);
  event Generated(address indexed a, string value);
  event Debug(string value);

  constructor() ERC721("AsciiPunks", "ASC") {
  }

  function enforcePrice(
    uint256 p
  ) private view {
    require(hasSaleStarted == true, "The sale hasn't started. Come back later!");
    require(totalSupply() <= TOKEN_LIMIT, "AsciiPunks sale has completed.");
    require(p >= PRICE, "Insufficient ether sent.");
  }

  function createPunk() external payable {
    enforcePrice(msg.value);

    // Punk punk = new Punk();
    // string[144] memory drawn = punk.drawPunk();

    // emit Generated(msg.sender, "nice");
    // _registerToken(punk);
  }

  // function _registerToken(string memory value) private {
  //   uint256 tokenId = totalSupply();

  //   id_to_value[tokenId] = value;
  //   value_to_id[value] = tokenId;


  //   _mint(msg.sender, tokenId);
  // }
}
