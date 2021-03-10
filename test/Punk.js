const Punk = artifacts.require("Punk");

contract("Punk test", async (accounts) => {
   it("should draw a punk", async () => {
    let instance = await Punk.deployed();
    let drawn = await instance.drawPunk();
    const baseHead =
      "            \n" +
      "            \n" +
      "   ┌────┐   \n" +
      "   │    ├┐  \n" +
      "   │═ ═ └│  \n" +
      "   │ ╘  └┘  \n" +
      "   │    │   \n" +
      "   │──  │   \n" +
      "   │    │   \n" +
      "   └──┘ │   \n" +
      "     │  │   \n" +
      "     │  │   \n";

    assert.equal(drawn, baseHead);
  });
});
