const AsciiPunks = artifacts.require('AsciiPunks');
const AsciiPunkFactory = artifacts.require('AsciiPunkFactory');

module.exports = function(deployer) {
  deployer.deploy(AsciiPunks);
  deployer.deploy(AsciiPunkFactory);
}
