const Punk = artifacts.require("Punk");

contract("Punk test", async (accounts) => {
  it("should do stuff", async () => {
    let instance = await Punk.deployed();
    let spliced = await instance.splice(
      ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
      ["a", "a", "a"],
      0
    );
    assert.deepEqual(spliced.slice(0, 3), ["a", "a", "a"]);
  });
});
