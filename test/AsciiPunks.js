const AsciiPunks = artifacts.require("AsciiPunks");

contract("AsciiPunks test", async (accounts) => {
  it("should splice", async () => {
    let instance = await AsciiPunks.deployed();
    instance.createPunk();
  });
});
