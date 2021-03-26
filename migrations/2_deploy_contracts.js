const AsciiPunks = artifacts.require('AsciiPunks')
const AsciiPunkFactory = artifacts.require('AsciiPunkFactory')

// contract addr of ascii punk factory on mainnet
const asciiPunkFactoryAddr = '0x3c24A5DF4F69199962b163CB5762be1E8367CbEb'; 

// contract of ascii punk factory on rinkeby
// const asciiPunkFactoryAddr = '0x324f2a0F784ED60a0Cf6EBE9D26dae6B321E2675';

module.exports = function(deployer, network, accounts) {
  deployer.then(async () => {
    AsciiPunkFactory.address = asciiPunkFactoryAddr;
    await deployer.link(AsciiPunkFactory, [AsciiPunks]);
    
    await deployer.deploy(
      AsciiPunks,
      {
        from: accounts[0],
        gas: 3000000,
        gasPrice: web3.utils.toWei(process.env.GAS_PRICE || '130', 'gwei'),
    
      }
    );
  });
}
