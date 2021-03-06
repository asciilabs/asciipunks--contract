// SPDX-License-Identifier: MIT

pragma abicoder v2;

contract Punk {
  uint internal constant ROW_LENGTH = 3;
  uint internal constant ROW_COUNT = 3;

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
}
