require('dotenv').config()
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
    process.env.CONTRACT_ADDRESS
  )
  await AsciiPunks.methods.pauseSale().call()
  callback()
}
