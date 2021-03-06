const AsciiPunks = artifacts.require('AsciiPunks');
const Punk = artifacts.require('Punk');

module.exports = function(deployer) {
  deployer.deploy(AsciiPunks);
  deployer.deploy(Punk);
}
