const AsciiPunks = artifacts.require('AsciiPunks');

module.exports = function(deployer) {
  deployer.deploy(AsciiPunks);
}
