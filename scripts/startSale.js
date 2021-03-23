const path = require('path')
const fs = require('fs')
const truffle = require('truffle')

module.exports = async (callback) => {
  const abi = fs.readFileSync(
    path.resolve(__dirname, '../build/contracts/AsciiPunks.json')
  )
  const abiJson = JSON.parse(abi).abi
  const AsciiPunks = new this.web3.eth.Contract(
    abiJson,
    process.env.RINKEBY_CONTRACT_ADDRESS
  )
  await AsciiPunks.methods.startSale().send({ from: web3.currentProvider.addresses[0] })
  callback()
}
