require('dotenv').config()
const path = require('path')
const fs = require('fs')
const truffle = require('truffle')
const { sortBy, uniq } = require('lodash')
const MersenneTwister = require('mersenne-twister')

module.exports = async (callback) => {
  const abi = fs.readFileSync(
    path.resolve(__dirname, '../build/contracts/AsciiPunks.json')
  )
  const me = web3.currentProvider.addresses[0]

  const abiJson = JSON.parse(abi).abi
  const AsciiPunks = new this.web3.eth.Contract(
    abiJson,
    process.env.MAINNET_CONTRACT_ADDRESS
  )

  async function punksForUser(address) {
    let userPunks = []

    const balance = parseInt(await AsciiPunks.methods.balanceOf(address).call())

    for (let index = 0; index < balance; index++) {
      const id = await AsciiPunks.methods.tokenOfOwnerByIndex(address, index).call()
      userPunks.push(parseInt(id))
    }
    return userPunks
  }

  function writeToCSVFile(hodlers) {
    const filename = 'output.csv';
    console.log(extractAsCSV(hodlers));
    fs.writeFileSync(filename, extractAsCSV(hodlers));
    console.log(`saved as ${filename}`);
  }

  function extractAsCSV(hodlers) {
    const header = ["owner, tokenIds"];
    const rows = Object.keys(hodlers).map(owner =>
      `${owner}, "${hodlers[owner].join(',')}"`
    );
    return header.concat(rows).join("\n");
  }

  const punksToGiveAway = await punksForUser(me)

  let hodlers = []
  for (let i = 0; i < 2048; i++) {
    hodlers.push(await AsciiPunks.methods.ownerOf(i+1).call())
  }
  hodlers = sortBy(uniq(hodlers))

  const genesisCommitTimestamp = 1614806483

  const generator = new MersenneTwister(genesisCommitTimestamp)

  let results = {}

  for (let i = 0; i < 340; i++) {
    const hodlerIndex = Math.floor(generator.random() * 725)
    results[hodlers[hodlerIndex]] = results[hodlers[hodlerIndex]] ? [punksToGiveAway[i], ...results[hodlers[hodlerIndex]]] : [punksToGiveAway[i]]
  }

  console.log(results)

  writeToCSVFile(results);

  callback()
}

