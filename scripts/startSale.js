const path = require('path')
const fs = require('fs')
const truffle = require('truffle')

module.exports = async () => {
  const abi = fs.readFileSync(
    path.resolve(__dirname, '../build/contracts/AsciiPunks.json')
  )
  const abiJson = JSON.parse(abi).abi
  const AsciiPunks = new this.web3.eth.Contract(
    abiJson,
    '0x3c24A5DF4F69199962b163CB5762be1E8367CbEb'
  )
  await AsciiPunks.methods.startSale().call()
}
