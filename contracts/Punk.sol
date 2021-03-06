// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

contract Punk {
  uint internal constant ROW_LENGTH = 12;
  uint internal constant ROW_COUNT = 12;
  uint internal constant MOUTH_LENGTH = ROW_LENGTH;

  uint internal constant MOUTH_ROW = 7;

  function splice(
    string[ROW_LENGTH * ROW_COUNT] memory rows,
    string[ROW_COUNT] memory newRow,
    uint rowNum
  ) public pure returns (string[ROW_LENGTH * ROW_COUNT] memory) {
    for (uint i = 0; i < ROW_LENGTH; i++) {
      rows[(rowNum * ROW_LENGTH) + i] = newRow[i];
    }

    return rows;
  }

  function drawMouth(
    string[ROW_LENGTH * ROW_COUNT] memory rows, 
    string[MOUTH_LENGTH] memory mouth
  ) public pure returns (string[ROW_LENGTH * ROW_COUNT] memory) {
    string[ROW_LENGTH * ROW_COUNT] memory res = splice(rows, mouth, MOUTH_ROW); 
    return res;
  }

  function chooseMouth(uint mouth) public pure returns (string[ROW_LENGTH] memory) {
    if (mouth == 0) {
      string[ROW_LENGTH] memory res = [" ", " ", " ", unicode"│", unicode"─", unicode"─", unicode" ", " ", unicode"│", " ", " ", " "];
      return res;
    }

    string[ROW_LENGTH] memory defaultRes = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "];
    return defaultRes;
  }

  function drawPunk() public pure returns (string[ROW_LENGTH * ROW_COUNT] memory) {
    string[ROW_LENGTH * ROW_COUNT] memory base = [
      " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
      " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
      " ", " ", " ", unicode"┌",  unicode"─",  unicode"─",  unicode"─",  unicode"─",  unicode"┐", " ", " ", " ",
      " ", " ", " ", unicode"│", " ", " ", " ", " ", unicode"├", unicode"┐", " ", " ",
      " ", " ", " ", unicode"│", " ", " ", " ", " ", unicode"└", unicode"│", " ", " ",
      " ", " ", " ", unicode"│", " ", " ", " ", " ", unicode"└", unicode"┘", " ", " ",
      " ", " ", " ", unicode"│", " ", " ", " ", " ", unicode"│", " ", " ", " ",
      " ", " ", " ", unicode"│", " ", " ", " ", " ", unicode"│", " ", " ", " ",
      " ", " ", " ", unicode"│", " ", " ", " ", " ", unicode"│", " ", " ", " ",
      " ", " ", " ", unicode"└", unicode"─", unicode"─", unicode"┘", " ", unicode"│", " ", " ", " ",
      " ", " ", " ", " ", " ", unicode"│", " ", " ", unicode"│", " ", " ", " ",
      " ", " ", " ", " ", " ", unicode"│", " ", " ", unicode"│", " ", " ", " "
    ];

    string[MOUTH_LENGTH] memory mouth = chooseMouth(0);

    return drawMouth(base, mouth);
  }
}
