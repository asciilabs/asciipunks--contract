const Punk = artifacts.require("Punk");

contract("Punk", () => {
  it("should be able to replace a row", () => {
    return Punk.deployed().then(() => {
      assert.equal(1, 0, "thes");
      /*
      assert.equal(
        newPunk[0],
        "a",
        "replaceRow should replace first character with a"
      );
      */
    });
  });
});
