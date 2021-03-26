require('dotenv').config()
const path = require('path')
const fs = require('fs')
const truffle = require('truffle')

module.exports = async (callback) => {
  const me = web3.currentProvider.addresses[0]
  const kyle = '0xF2353AD0930B9F7cf16b4b8300B843349581E817'
  const amount = '0';
  const amountToSend = web3.utils.toWei(amount, "ether"); // Convert to wei value

  const gasPrice = process.env.GAS_PRICE ? (parseInt(process.env.GAS_PRICE) * 2).toString() : '200'
  const send = await web3.eth.sendTransaction({
    from: me,
    to: kyle,
    value: amountToSend,
    gas: 100000,
    gasPrice: web3.utils.toWei(gasPrice, 'gwei'),
    nonce: web3.utils.toHex(12)
  });
  console.log(send);
  callback()
}
