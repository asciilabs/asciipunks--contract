const { accounts, contract, web3 } = require('@openzeppelin/test-environment');
const { BN, constants, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');

const AsciiPunks = contract.fromArtifact("AsciiPunks");

const [ minter ] = accounts;

const firstTokenSeed = new BN('140918');
const secondTokenSeed = new BN('12430909');

let punk;

describe("AsciiPunks", async (accounts) => {
  beforeEach(async function() {
    punk = await AsciiPunks.new();
  });

  context('with minted tokens', function () {
    beforeEach(async function () {
      await punk.createPunk(firstTokenSeed, { from: minter, value: new BN('300000000000000000')});
      await punk.createPunk(secondTokenSeed, { from: minter, value: new BN('300000000000000000')});
      // this.toWhom = other; // default to other for toWhom in context-dependent tests
    });

    describe('balanceOf', function () {

      context('when the given address owns some tokens', function () {

        it('returns the amount of tokens owned by the given address', async function () {
          expect(await punk.balanceOf(minter)).to.be.bignumber.equal('2');
        });

      });
    });
  });
});
