const Punk = artifacts.require("Punk");

contract("Punk test", async accounts => {
  it("should do stuff", async () => {
    let instance = await Punk.deployed();
    // let balance = await instance.getBalance.call(accounts[0]);
    assert.equal(1, 2);
  });
});
