const truffleAssert = require('truffle-assertions');
const AsciiPunks = artifacts.require("AsciiPunks");

contract("AsciiPunks", async (accounts) => {
  let instance;
  let fundingSize = 300;
  const fundingAccount = accounts[0];

  describe('#createPunk()', () => {
    it("should reject when not enough wei provided", async () => {
      instance = await AsciiPunks.deployed();

      await truffleAssert.fails(
        instance.createPunk({ from: fundingAccount, value: 0 }),
        truffleAssert.ErrorType.REVERT
      );
    });
  });
});
