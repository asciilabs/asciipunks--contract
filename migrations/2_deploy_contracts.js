const AsciiPunks = artifacts.require('AsciiPunks');
const AsciiPunkFactory = artifacts.require('AsciiPunkFactory');

module.exports = function(deployer, network, accounts) {
  deployer.then(async () => {
    await deployer.deploy(AsciiPunkFactory);
    await deployer.link(AsciiPunkFactory, [AsciiPunks]);
    await deployer.deploy(AsciiPunks);
    let punkInstance = AsciiPunks.deployed();
    console.log(punkInstance);
  });
}
