// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

contract Punk {
  event Debug(string value);

  uint private constant LENGTH = 12;
  uint private constant MOUTH_START_ROW = 7;

  // function chooseMouth(string memory _name) returns (string memory) {
  //   uint rand = uint(keccack256(abi.encodePacked(_str)));
  // }

  function drawPunk() public pure
  returns (string memory) {
    string memory hat = 
      unicode"            \n"
      unicode"            \n"
      unicode"   ┌────┐   \n";

    string memory eyes = 
      unicode"   │    ├┐  \n"
      unicode"   │═ ═ └│  \n"
      unicode"   │ ╘  └┘  \n";

    string memory moustache = unicode"   │    │   \n";

    string memory mouth = unicode"   │──  │   \n";

    string memory chin = 
      unicode"   │    │   \n"
      unicode"   └──┘ │   \n";

    string memory neck =
      unicode"     │  │   \n"
      unicode"     │  │   \n";

    return string(abi.encodePacked(hat, eyes, moustache, mouth, chin, neck));
  }
}
