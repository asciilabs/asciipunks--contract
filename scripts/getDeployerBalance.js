require('dotenv').config()
const path = require('path')
const truffle = require('truffle')

module.exports = async (callback) => {
  const deployer = web3.currentProvider.addresses[0]
  console.log('deployer address: ', deployer)
  let balance = await web3.eth.getBalance(deployer)
  console.log('deployer balance: ', web3.utils.fromWei(balance));
  callback()
}
