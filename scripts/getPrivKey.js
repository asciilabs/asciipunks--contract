const pkutils = require('ethereum-mnemonic-privatekey-utils');

require('dotenv').config()
const path = require('path')
const truffle = require('truffle')

module.exports = async (callback) => {
  const privateKeyGen = pkutils.getPrivateKeyFromMnemonic(process.env.mnemonic);
  console.log(privateKeyGen);
  callback()
}
