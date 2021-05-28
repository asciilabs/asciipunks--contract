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
    process.env.MAINNET_CONTRACT_ADDRESS
  )
  await AsciiPunks.methods.release('0x9386efb02a55A1092dC19f0E68a9816DDaAbDb5b').send({
    from: web3.currentProvider.addresses[0],
    gasLimit: 100000,
    gasPrice: web3.utils.toWei('60', 'gwei'),
  })
  callback()
}
