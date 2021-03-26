const web3 = require('web3')
const Migrations = artifacts.require('Migrations')

module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    await deployer.deploy(Migrations, {
      from: accounts[0],
      gas: 200000,
      gasPrice: web3.utils.toWei('130', 'gwei'),
    })
  })
}
