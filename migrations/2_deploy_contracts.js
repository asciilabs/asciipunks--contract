const AsciiPunks = artifacts.require('AsciiPunks')
const AsciiPunkFactory = artifacts.require('AsciiPunkFactory')

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    await deployer.deploy(AsciiPunkFactory, {
      from: accounts[0],
      gas: 3000000,
      gasPrice: web3.utils.toWei('130', 'gwei'),
    })
    await deployer.link(AsciiPunkFactory, [AsciiPunks])
    await deployer.deploy(AsciiPunks, {
      from: accounts[0],
      gas: 5000000,
      gasPrice: web3.utils.toWei('130', 'gwei'),
    })
    let punkInstance = AsciiPunks.deployed()
    console.log(punkInstance)
  })
}
