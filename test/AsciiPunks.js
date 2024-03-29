// SPDX-License-Identifier: MIT

const { expect } = require('chai');
const { accounts, contract, web3 } = require('@openzeppelin/test-environment');
const { send, ether, balance, BN, constants, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { shouldSupportInterfaces } = require('./SupportsInterface.js');

const AsciiPunkFactory = contract.fromArtifact("AsciiPunkFactory");
const AsciiPunks = contract.fromArtifact("AsciiPunks");
const ERC721ReceiverMock = contract.fromArtifact('ERC721ReceiverMock');

const { ZERO_ADDRESS } = constants;
const RECEIVER_MAGIC_VALUE = '0x150b7a02';
const Error = [ 'None', 'RevertWithMessage', 'RevertWithoutMessage', 'Panic' ]
  .reduce((acc, entry, idx) => Object.assign({ [entry]: idx }, acc), {});
const [owner, newOwner, approved, anotherApproved, operator, other] = accounts

const firstTokenSeed = new BN('140918');
const secondTokenSeed = new BN('12430909');
const firstTokenId = new BN('1');
const secondTokenId = new BN('2');
const nonExistentTokenId = new BN('13');
const price = new BN('50000000000000000');

const CREATOR_ONE = '0x9386efb02a55A1092dC19f0E68a9816DDaAbDb5b';
const CREATOR_TWO = '0xF2353AD0930B9F7cf16b4b8300B843349581E817';

let punk;

describe("AsciiPunks", async (accounts) => {
  beforeEach(async function() {
    const punkFactoryLibrary = await AsciiPunkFactory.new();
    await AsciiPunks.detectNetwork();
    await AsciiPunks.link('AsciiPunkFactory', punkFactoryLibrary.address);
    this.token = await AsciiPunks.new(); 
    await this.token.startSale();
  });

  context("ERC721", async () => {
    shouldSupportInterfaces([
      'ERC165',
      'ERC721',
    ]);

    context('bonding curve', function () { 
      this.timeout(300000); 

      it('prices punks according to a curve', async function() {
        let i;
        for (i = 0; i < 256; i++) {
          ({ logs: this.logs} = await this.token.createPunk(i, { from: owner, value: price}));
          expectEvent.inLogs(this.logs, 'Generated');
          console.log(`minted punk ${i}`);
        };

        await expectRevert(this.token.createPunk(i, { from: owner, value: price}), "ERC721: insufficient ether");

        for (i = 256; i < 512; i++) {
          ({ logs: this.logs} = await this.token.createPunk(i, { from: owner, value: new BN('100000000000000000')}));
          expectEvent.inLogs(this.logs, 'Generated');
          console.log(`minted punk ${i}`);
        };
        await expectRevert(this.token.createPunk(i, { from: owner, value: new BN('100000000000000000')}), "ERC721: insufficient ether");

        for (i = 512; i < 1024; i++) {
          ({ logs: this.logs} = await this.token.createPunk(i, { from: owner, value: new BN('200000000000000000')}));
          expectEvent.inLogs(this.logs, 'Generated');
          console.log(`minted punk ${i}`);
        };
        await expectRevert(this.token.createPunk(i, { from: owner, value: new BN('200000000000000000')}), "ERC721: insufficient ether");

        for (i = 1024; i < 1536; i++) {
          ({ logs: this.logs} = await this.token.createPunk(i, { from: owner, value: new BN('300000000000000000')}));
          expectEvent.inLogs(this.logs, 'Generated');
          console.log(`minted punk ${i}`);
        };
        await expectRevert(this.token.createPunk(i, { from: owner, value: new BN('300000000000000000')}), "ERC721: insufficient ether");

        for (i = 1536; i < 2048; i++) {
          ({ logs: this.logs} = await this.token.createPunk(i, { from: owner, value: new BN('400000000000000000')}));
          expectEvent.inLogs(this.logs, 'Generated');
          console.log(`minted punk ${i}`);
        };
        await expectRevert(this.token.createPunk(i, { from: owner, value: new BN('400000000000000000')}), "ERC721: maximum number of tokens already minted");
      });
    });

    context('startSale / pauseSale', function () {
      it('only allows owner to pause and unpause', async function () {
        await expectRevert(
          this.token.pauseSale({ from: approved }),
          'Ownable: caller is not the owner.'
        );     
      });
    });

    context('Payment splitter', function () {
      this.timeout(5000); 

      context('once deployed', function () {
        it('has total shares', async function () {
          expect(await this.token.totalShares()).to.be.bignumber.equal('10');
        });

        it('has payees', async function () {
          expect(await this.token.payee(0)).to.equal(CREATOR_ONE);
          expect(await this.token.released(CREATOR_ONE)).to.be.bignumber.equal('0');
          expect(await this.token.payee(1)).to.equal(CREATOR_TWO);
          expect(await this.token.released(CREATOR_TWO)).to.be.bignumber.equal('0');

        });

        it('stores payments in contract from creating punks', async function () {
          await this.token.createPunk(firstTokenSeed, { from: other, value: price});
          await this.token.createPunk(secondTokenSeed, { from: other, value: price});
          expect(await balance.current(this.token.address)).to.be.bignumber.equal(ether('0.1'));
        });

        it('accepts payments', async function () {
          const amount = ether('0.1');
          await send.ether(owner, this.token.address, amount);

          expect(await balance.current(this.token.address)).to.be.bignumber.equal(amount);
        });

        describe('shares', async function () {
          it('stores shares if address is payee', async function () {
            expect(await this.token.shares(CREATOR_ONE)).to.be.bignumber.not.equal('0');
          });

          it('does not store shares if address is not payee', async function () {
            expect(await this.token.shares(other)).to.be.bignumber.equal('0');
          });
        });

        describe('release', async function () {
          it('reverts if no funds to claim', async function () {
            await expectRevert(this.token.release(CREATOR_ONE),
              'PaymentSplitter: account is not due payment',
            );
          });

          it('reverts if non-payee want to claim', async function () {
            await this.token.createPunk(firstTokenSeed, { from: other, value: price});
            await expectRevert(this.token.release(other),
              'PaymentSplitter: account has no shares',
            );
          });
        });

        it('distributes funds to payees', async function () {
          await this.token.createPunk(new BN('1'), { from: other, value: price});
          await this.token.createPunk(new BN('2'), { from: other, value: price});
          await this.token.createPunk(new BN('3'), { from: other, value: price});
          await this.token.createPunk(new BN('4'), { from: other, value: price});
          await this.token.createPunk(new BN('5'), { from: other, value: price});
          await this.token.createPunk(new BN('6'), { from: other, value: price});
          await this.token.createPunk(new BN('7'), { from: other, value: price});
          await this.token.createPunk(new BN('8'), { from: other, value: price});
          await this.token.createPunk(new BN('9'), { from: other, value: price});
          await this.token.createPunk(new BN('10'), { from: other, value: price});
          await this.token.createPunk(new BN('11'), { from: other, value: price});
          await this.token.createPunk(new BN('12'), { from: other, value: price});
          await this.token.createPunk(new BN('13'), { from: other, value: price});
          await this.token.createPunk(new BN('14'), { from: other, value: price});
          await this.token.createPunk(new BN('15'), { from: other, value: price});
          await this.token.createPunk(new BN('16'), { from: other, value: price});
          await this.token.createPunk(new BN('17'), { from: other, value: price});
          await this.token.createPunk(new BN('18'), { from: other, value: price});
          await this.token.createPunk(new BN('19'), { from: other, value: price});
          await this.token.createPunk(new BN('20'), { from: other, value: price});


          // receive funds
          const initBalance = await balance.current(this.token.address);
          expect(initBalance).to.be.bignumber.equal(ether('1'));

          // distribute to payees

          const initAmount1 = await balance.current(CREATOR_ONE);
          const { logs: logs1 } = await this.token.release(CREATOR_ONE, { gasPrice: 0 });
          const profit1 = (await balance.current(CREATOR_ONE)).sub(initAmount1);
          expect(profit1).to.be.bignumber.equal(ether('0.70'));
          expectEvent.inLogs(logs1, 'PaymentReleased', { to: CREATOR_ONE, amount: profit1 });

          const initAmount2 = await balance.current(CREATOR_TWO);
          const { logs: logs2 } = await this.token.release(CREATOR_TWO, { gasPrice: 0 });
          const profit2 = (await balance.current(CREATOR_TWO)).sub(initAmount2);
          expect(profit2).to.be.bignumber.equal(ether('0.30'));
          expectEvent.inLogs(logs2, 'PaymentReleased', { to: CREATOR_TWO, amount: profit2 });

          // end balance should be zero
          expect(await balance.current(this.token.address)).to.be.bignumber.equal('0');

          // check correct funds released accounting
          expect(await this.token.totalReleased()).to.be.bignumber.equal(initBalance);
        });
      });
    });


    context('with minted tokens', function () {
      beforeEach(async function () {
        await this.token.createPunk(firstTokenSeed, { from: owner, value: price});
        await this.token.createPunk(secondTokenSeed, { from: owner, value: price});
        this.toWhom = other;
      });

      describe('balanceOf', function () {
        context('when the given address owns some tokens', function () {
          it('returns the amount of tokens owned by the given address', async function () {
            expect(await this.token.balanceOf(owner)).to.be.bignumber.equal('2');
          });
        });

        context('when the given address does not own any tokens', function () {
          it('returns 0', async function () {
            expect(await this.token.balanceOf(this.toWhom)).to.be.bignumber.equal('0');
          });
        });

        context('when querying the zero address', function () {
          it('throws', async function () {
            await expectRevert(
              this.token.balanceOf(ZERO_ADDRESS), 'ERC721: balance query for the zero address',
            );
          });
        })
      });

      describe('ownerOf', function () {
        context('when the given token ID was tracked by punk', function () {
          const tokenId = firstTokenId;

          it('returns the owner of the given token ID', async function () {
            expect(await this.token.ownerOf(tokenId)).to.be.equal(owner);
          });
        });

        context('when the given token ID does not exist', function () {
          const tokenId = nonExistentTokenId;

          it('reverts', async function () {
            await expectRevert(
              this.token.ownerOf(tokenId), 'ERC721: query for nonexistent token',
            );
          });
        });
      });

      describe('transfers', function () {
        const tokenId = firstTokenId;
        const data = '0x42';

        let logs = null;

        beforeEach(async function () {
          await this.token.approve(approved, tokenId, { from: owner });
          await this.token.setApprovalForAll(operator, true, { from: owner });
        });

        const transferWasSuccessful = function ({ owner, tokenId, approved }) {
          it('transfers the ownership of the given token ID to the given address', async function () {
            expect(await this.token.ownerOf(tokenId)).to.be.equal(this.toWhom);
          });

          it('emits a Transfer event', async function () {

            expectEvent.inLogs(logs, 'Transfer', { from: owner, to: this.toWhom, tokenId: tokenId });
          });

          it('clears the approval for the token ID', async function () {
            expect(await this.token.getApproved(tokenId)).to.be.equal(ZERO_ADDRESS);
          });

          it('emits an Approval event', async function () {
            expectEvent.inLogs(logs, 'Approval', { owner, approved: this.toWhom, tokenId: tokenId });
          });

          it('adjusts owners balances', async function () {
            expect(await this.token.balanceOf(owner)).to.be.bignumber.equal('1');
          });

          it('adjusts owners tokens by index', async function () {
            if (!this.token.tokenOfOwnerByIndex) return;

            expect(await this.token.tokenOfOwnerByIndex(this.toWhom, 0)).to.be.bignumber.equal(tokenId);

            expect(await this.token.tokenOfOwnerByIndex(owner, 0)).to.be.bignumber.not.equal(tokenId);
          });
        };

        const shouldTransferTokensByUsers = function (transferFunction) {
          context('when called by the owner', function () {
            beforeEach(async function () {
              ({ logs } = await transferFunction.call(this, owner, this.toWhom, tokenId, { from: owner }));
            });
            transferWasSuccessful({ owner, tokenId, approved });
          });

          context('when called by the approved individual', function () {
            beforeEach(async function () {
              ({ logs } = await transferFunction.call(this, owner, this.toWhom, tokenId, { from: approved }));
            });
            transferWasSuccessful({ owner, tokenId, approved });
          });

          context('when called by the operator', function () {
            beforeEach(async function () {
              ({ logs } = await transferFunction.call(this, owner, this.toWhom, tokenId, { from: operator }));
            });
            transferWasSuccessful({ owner, tokenId, approved });
          });

          context('when called by the owner without an approved user', function () {
            beforeEach(async function () {
              await this.token.approve(ZERO_ADDRESS, tokenId, { from: owner });
              ({ logs } = await transferFunction.call(this, owner, this.toWhom, tokenId, { from: operator }));
            });
            transferWasSuccessful({ owner, tokenId, approved: null });
          });

          context('when sent to the owner', function () {
            beforeEach(async function () {
              ({ logs } = await transferFunction.call(this, owner, owner, tokenId, { from: owner }));
            });

            it('keeps ownership of the token', async function () {
              expect(await this.token.ownerOf(tokenId)).to.be.equal(owner);
            });

            it('clears the approval for the token ID', async function () {
              expect(await this.token.getApproved(tokenId)).to.be.equal(ZERO_ADDRESS);
            });

            it('emits only a transfer event', async function () {
              expectEvent.inLogs(logs, 'Transfer', {
                from: owner,
                to: owner,
                tokenId: tokenId,
              });
            });

            it('keeps the owner balance', async function () {
              expect(await this.token.balanceOf(owner)).to.be.bignumber.equal('2');
            });

            it('keeps same tokens by index', async function () {
              if (!this.token.tokenOfOwnerByIndex) return;
              const tokensListed = await Promise.all(
                [0, 1].map(i => this.token.tokenOfOwnerByIndex(owner, i)),
              );
              expect(tokensListed.map(t => t.toNumber())).to.have.members(
                [firstTokenId.toNumber(), secondTokenId.toNumber()],
              );
            });
          });

          context('when the address of the previous owner is incorrect', function () {
            it('reverts', async function () {
              await expectRevert(
                transferFunction.call(this, other, other, tokenId, { from: owner }),
                'ERC721: transfer of token that is not own',
              );
            });
          });

          context('when the sender is not authorized for the token id', function () {
            it('reverts', async function () {
              await expectRevert(
                transferFunction.call(this, owner, other, tokenId, { from: other }),
                'ERC721: transfer caller is not owner nor approved',
              );
            });
          });

          context('when the given token ID does not exist', function () {
            it('reverts', async function () {
              await expectRevert(
                transferFunction.call(this, owner, other, nonExistentTokenId, { from: owner }),
                'ERC721: query for nonexistent token',
              );
            });
          });

          context('when the address to transfer the token to is the zero address', function () {
            it('reverts', async function () {
              await expectRevert(
                transferFunction.call(this, owner, ZERO_ADDRESS, tokenId, { from: owner }),
                'ERC721: transfer to the zero address',
              );
            });
          });
        };

        describe('via transferFrom', function () {
          shouldTransferTokensByUsers(function (from, to, tokenId, opts) {
            return this.token.transferFrom(from, to, tokenId, opts);
          });
        });

        describe('via safeTransferFrom', function () {
          const safeTransferFromWithData = function (from, to, tokenId, opts) {
            return this.token.methods['safeTransferFrom(address,address,uint256,bytes)'](from, to, tokenId, data, opts);
          };

          const safeTransferFromWithoutData = function (from, to, tokenId, opts) {
            return this.token.methods['safeTransferFrom(address,address,uint256)'](from, to, tokenId, opts);
          };

          const shouldTransferSafely = function (transferFun, data) {
            describe('to a user account', function () {
              shouldTransferTokensByUsers(transferFun);
            });

            describe('to a valid receiver contract', function () {
              beforeEach(async function () {
                this.receiver = await ERC721ReceiverMock.new(RECEIVER_MAGIC_VALUE, Error.None);
                this.toWhom = this.receiver.address;
              });

              shouldTransferTokensByUsers(transferFun);

              it('calls onERC721Received', async function () {
                const receipt = await transferFun.call(this, owner, this.receiver.address, tokenId, { from: owner });

                await expectEvent.inTransaction(receipt.tx, ERC721ReceiverMock, 'Received', {
                  operator: owner,
                  from: owner,
                  tokenId: tokenId,
                  data: data,
                });
              });

              it('calls onERC721Received from approved', async function () {
                const receipt = await transferFun.call(this, owner, this.receiver.address, tokenId, { from: approved });

                await expectEvent.inTransaction(receipt.tx, ERC721ReceiverMock, 'Received', {
                  operator: approved,
                  from: owner,
                  tokenId: tokenId,
                  data: data,
                });
              });

              describe('with an invalid token id', function () {
                it('reverts', async function () {
                  await expectRevert(
                    transferFun.call(
                      this,
                      owner,
                      this.receiver.address,
                      nonExistentTokenId,
                      { from: owner },
                    ),
                    'ERC721: query for nonexistent token',
                  );
                });
              });
            });
          };

          describe('with data', function () {
            shouldTransferSafely(safeTransferFromWithData, data);
          });

          describe('without data', function () {
            shouldTransferSafely(safeTransferFromWithoutData, null);
          });

          describe('to a receiver contract returning unexpected value', function () {
            it('reverts', async function () {
              const invalidReceiver = await ERC721ReceiverMock.new('0x42', Error.None);
              await expectRevert(
                this.token.safeTransferFrom(owner, invalidReceiver.address, tokenId, { from: owner }),
                'ERC721: transfer to non ERC721Receiver implementer',
              );
            });
          });

          describe('to a receiver contract that reverts with message', function () {
            it('reverts', async function () {
              const revertingReceiver = await ERC721ReceiverMock.new(RECEIVER_MAGIC_VALUE, Error.RevertWithMessage);
              await expectRevert(
                this.token.safeTransferFrom(owner, revertingReceiver.address, tokenId, { from: owner }),
                'ERC721ReceiverMock: reverting',
              );
            });
          });

          describe('to a receiver contract that reverts without message', function () {
            it('reverts', async function () {
              const revertingReceiver = await ERC721ReceiverMock.new(RECEIVER_MAGIC_VALUE, Error.RevertWithoutMessage);
              await expectRevert(
                this.token.safeTransferFrom(owner, revertingReceiver.address, tokenId, { from: owner }),
                'ERC721: transfer to non ERC721Receiver implementer',
              );
            });
          });

          describe('to a receiver contract that panics', function () {
            it('reverts', async function () {
              const revertingReceiver = await ERC721ReceiverMock.new(RECEIVER_MAGIC_VALUE, Error.Panic);
              await expectRevert.unspecified(
                this.token.safeTransferFrom(owner, revertingReceiver.address, tokenId, { from: owner }),
              );
            });
          });

          describe('to a contract that does not implement the required function', function () {
            it('reverts', async function () {
              const nonReceiver = this.token;
              await expectRevert(
                this.token.safeTransferFrom(owner, nonReceiver.address, tokenId, { from: owner }),
                'ERC721: transfer to non ERC721Receiver implementer',
              );
            });
          });
        });
      });

      describe('approve', function () {
        const tokenId = firstTokenId;

        let logs = null;

        const itClearsApproval = function () {
          it('clears approval for the token', async function () {
            expect(await this.token.getApproved(tokenId)).to.be.equal(ZERO_ADDRESS);
          });
        };

        const itApproves = function (address) {
          it('sets the approval for the target address', async function () {
            expect(await this.token.getApproved(tokenId)).to.be.equal(address);
          });
        };

        const itEmitsApprovalEvent = function (address) {
          it('emits an approval event', async function () {
            expectEvent.inLogs(logs, 'Approval', {
              owner: owner,
              approved: address,
              tokenId: tokenId,
            });
          });
        };

        context('when clearing approval', function () {
          context('when there was no prior approval', function () {
            beforeEach(async function () {
              ({ logs } = await this.token.approve(ZERO_ADDRESS, tokenId, { from: owner }));
            });

            itClearsApproval();
            itEmitsApprovalEvent(ZERO_ADDRESS);
          });

          context('when there was a prior approval', function () {
            beforeEach(async function () {
              await this.token.approve(approved, tokenId, { from: owner });
              ({ logs } = await this.token.approve(ZERO_ADDRESS, tokenId, { from: owner }));
            });

            itClearsApproval();
            itEmitsApprovalEvent(ZERO_ADDRESS);
          });
        });

        context('when approving a non-zero address', function () {
          context('when there was no prior approval', function () {
            beforeEach(async function () {
              ({ logs } = await this.token.approve(approved, tokenId, { from: owner }));
            });

            itApproves(approved);
            itEmitsApprovalEvent(approved);
          });

          context('when there was a prior approval to the same address', function () {
            beforeEach(async function () {
              await this.token.approve(approved, tokenId, { from: owner });
              ({ logs } = await this.token.approve(approved, tokenId, { from: owner }));
            });

            itApproves(approved);
            itEmitsApprovalEvent(approved);
          });

          context('when there was a prior approval to a different address', function () {
            beforeEach(async function () {
              await this.token.approve(anotherApproved, tokenId, { from: owner });
              ({ logs } = await this.token.approve(anotherApproved, tokenId, { from: owner }));
            });

            itApproves(anotherApproved);
            itEmitsApprovalEvent(anotherApproved);
          });
        });

        context('when the address that receives the approval is the owner', function () {
          it('reverts', async function () {
            await expectRevert(
              this.token.approve(owner, tokenId, { from: owner }), 'ERC721: approval to current owner',
            );
          });
        });

        context('when the sender does not own the given token ID', function () {
          it('reverts', async function () {
            await expectRevert(this.token.approve(approved, tokenId, { from: other }),
              'ERC721: approve caller is not owner nor approved');
          });
        });

        context('when the sender is approved for the given token ID', function () {
          it('reverts', async function () {
            await this.token.approve(approved, tokenId, { from: owner });
            await expectRevert(this.token.approve(anotherApproved, tokenId, { from: approved }),
              'ERC721: approve caller is not owner nor approved for all');
          });
        });

        context('when the sender is an operator', function () {
          beforeEach(async function () {
            await this.token.setApprovalForAll(operator, true, { from: owner });
            ({ logs } = await this.token.approve(approved, tokenId, { from: operator }));
          });

          itApproves(approved);
          itEmitsApprovalEvent(approved);
        });

        context('when the given token ID does not exist', function () {
          it('reverts', async function () {
            await expectRevert(this.token.approve(approved, nonExistentTokenId, { from: operator }),
              'ERC721: query for nonexistent token');
          });
        });
      });

      describe('setApprovalForAll', function () {
        context('when the operator willing to approve is not the owner', function () {
          context('when there is no operator approval set by the sender', function () {
            it('approves the operator', async function () {
              await this.token.setApprovalForAll(operator, true, { from: owner });

              expect(await this.token.isApprovedForAll(owner, operator)).to.equal(true);
            });

            it('emits an approval event', async function () {
              const { logs } = await this.token.setApprovalForAll(operator, true, { from: owner });

              expectEvent.inLogs(logs, 'ApprovalForAll', {
                owner: owner,
                operator: operator,
                approved: true,
              });
            });
          });

          context('when the operator was set as not approved', function () {
            beforeEach(async function () {
              await this.token.setApprovalForAll(operator, false, { from: owner });
            });

            it('approves the operator', async function () {
              await this.token.setApprovalForAll(operator, true, { from: owner });

              expect(await this.token.isApprovedForAll(owner, operator)).to.equal(true);
            });

            it('emits an approval event', async function () {
              const { logs } = await this.token.setApprovalForAll(operator, true, { from: owner });

              expectEvent.inLogs(logs, 'ApprovalForAll', {
                owner: owner,
                operator: operator,
                approved: true,
              });
            });

            it('can unset the operator approval', async function () {
              await this.token.setApprovalForAll(operator, false, { from: owner });

              expect(await this.token.isApprovedForAll(owner, operator)).to.equal(false);
            });
          });

          context('when the operator was already approved', function () {
            beforeEach(async function () {
              await this.token.setApprovalForAll(operator, true, { from: owner });
            });

            it('keeps the approval to the given address', async function () {
              await this.token.setApprovalForAll(operator, true, { from: owner });

              expect(await this.token.isApprovedForAll(owner, operator)).to.equal(true);
            });

            it('emits an approval event', async function () {
              const { logs } = await this.token.setApprovalForAll(operator, true, { from: owner });

              expectEvent.inLogs(logs, 'ApprovalForAll', {
                owner: owner,
                operator: operator,
                approved: true,
              });
            });
          });
        });

        context('when the operator is the owner', function () {
          it('reverts', async function () {
            await expectRevert(this.token.setApprovalForAll(owner, true, { from: owner }),
              'ERC721: approve to caller');
          });
        });
      });

      describe('getApproved', async function () {
        context('when token is not minted', async function () {
          it('reverts', async function () {
            await expectRevert(
              this.token.getApproved(nonExistentTokenId),
              'ERC721: query for nonexistent token',
            );
          });
        });

        context('when token has been minted ', async function () {
          it('should return the zero address', async function () {
            expect(await this.token.getApproved(firstTokenId)).to.be.equal(
              ZERO_ADDRESS,
            );
          });

          context('when account has been approved', async function () {
            beforeEach(async function () {
              await this.token.approve(approved, firstTokenId, { from: owner });
            });

            it('returns approved account', async function () {
              expect(await this.token.getApproved(firstTokenId)).to.be.equal(approved);
            });
          });
        });
      });
    });

    describe('draw', function () {
      let logs = null;

      beforeEach(async function () {
        ({ logs: this.logs } = await this.token.createPunk(
          firstTokenSeed,
          { from: owner, value: price}
        ));
      });

      it('returns the punk string', async function () {
        const punk = await this.token.draw(new BN('1'));
        expect(punk.length).to.equal(156)
      });
    });

    describe('createPunk', function () {
      let logs = null;

      // context.only('randomization', async function () {
      //   this.timeout(300000); 

      //   it('randomly generates cool AsciiPunks', async function() {
      //     let i;
      //     for (i = 0; i < 1000; i++) {
      //       let punk = await this.token.createPunk(i, { from: owner, value: price});
      //       console.log(punk.logs[0].args.value);
      //     };
      //   });
      // });

      it('reverts when not enough ether sent', async function () {
        await expectRevert(
          this.token.createPunk(
            firstTokenSeed,
            { from: owner, value: new BN('300')}
          ),
          "ERC721: insufficient ether"
        );
      });

      context('with minted token', async function () {
        beforeEach(async function () {
          ({ logs: this.logs } = await this.token.createPunk(
            firstTokenSeed,
            { from: owner, value: price}
          ));
        });

        it('emits a Generated event', async function () {
          expectEvent.inLogs(this.logs, 'Generated', { index: new BN(1), a: owner });
        });

        it('emits a Transfer event', function () {
          expectEvent.inLogs(this.logs, 'Transfer', { from: ZERO_ADDRESS, to: owner, tokenId: firstTokenId });
        });

        it('creates the token', async function () {
          expect(await this.token.balanceOf(owner)).to.be.bignumber.equal('1');
          expect(await this.token.ownerOf(firstTokenId)).to.equal(owner);
        });

        // skipping this test because we now add randomness to seed
        // it('reverts when using a seed that already exists', async function () {
        //   await expectRevert(
        //     this.token.createPunk(
        //       firstTokenSeed,
        //       { from: owner, value: price }
        //     ),
        //     'ERC721: seed already used'
        //   );
        // });
      });

      // Leave commented out because it's very slow
      // context.only('with token limit number of tokens minted', async function() {
      //   this.timeout(300000); 
      //   beforeEach(async function () {
      //     for (let i = 0; i < 512; i++) {
      //       await this.token.createPunk(i, { from: owner, value: price})
      //     }
      //   });

      //   it('reverts when already minted 512 tokens', async function () {
      //     await expectRevert(
      //       this.token.createPunk(
      //         new BN('1000'),
      //         { from: owner, value: price }
      //       ),
      //       'ERC721: maximum number of tokens already minted'
      //     );
      //   });
      // });
    });
  });

  context("ERC721Enumerable", async () => {
    shouldSupportInterfaces([
      'ERC721Enumerable',
    ]);

    context('with minted tokens', function () {
      beforeEach(async function () {
        await this.token.createPunk(firstTokenSeed, { from: owner, value: price});
        await this.token.createPunk(secondTokenSeed, { from: owner, value: price});
        this.toWhom = other; // default to other for toWhom in context-dependent tests
      });

      describe('totalSupply', function () {
        it('returns total token supply', async function () {
          expect(await this.token.totalSupply()).to.be.bignumber.equal('2');
        });
      });

      describe('tokenOfOwnerByIndex', function () {
        describe('when the given index is lower than the amount of tokens owned by the given address', function () {
          it('returns the token ID placed at the given index', async function () {
            expect(await this.token.tokenOfOwnerByIndex(owner, 0)).to.be.bignumber.equal(firstTokenId);
          });
        });

        describe('when the index is greater than or equal to the total tokens owned by the given address', function () {
          it('reverts', async function () {
            await expectRevert(
              this.token.tokenOfOwnerByIndex(owner, 2), 'ERC721Enumerable: owner index out of bounds',
            );
          });
        });

        describe('when the given address does not own any token', function () {
          it('reverts', async function () {
            await expectRevert(
              this.token.tokenOfOwnerByIndex(other, 0), 'ERC721Enumerable: owner index out of bounds',
            );
          });
        });

        describe('after transferring all tokens to another user', function () {
          beforeEach(async function () {
            await this.token.transferFrom(owner, other, firstTokenId, { from: owner });
            await this.token.transferFrom(owner, other, secondTokenId, { from: owner });
          });

          it('returns correct token IDs for target', async function () {
            expect(await this.token.balanceOf(other)).to.be.bignumber.equal('2');
            const tokensListed = await Promise.all(
              [0, 1].map(i => this.token.tokenOfOwnerByIndex(other, i)),
            );
            expect(tokensListed.map(t => t.toNumber())).to.have.members([firstTokenId.toNumber(),
              secondTokenId.toNumber()]);
          });

          it('returns empty collection for original owner', async function () {
            expect(await this.token.balanceOf(owner)).to.be.bignumber.equal('0');
            await expectRevert(
              this.token.tokenOfOwnerByIndex(owner, 0), 'ERC721Enumerable: owner index out of bounds',
            );
          });
        });
      });

      describe('tokenByIndex', function () {
        it('returns all tokens', async function () {
          const tokensListed = await Promise.all(
            [0, 1].map(i => this.token.tokenByIndex(i)),
          );
          expect(tokensListed.map(t => t.toNumber())).to.have.members([0, 1]);
        });

        it('reverts if index is greater than supply', async function () {
          await expectRevert(
            this.token.tokenByIndex(2), 'ERC721Enumerable: global index out of bounds',
          );
        });
      });
    });
  });

  context("ERC721Metadata", async () => {
    shouldSupportInterfaces([
      'ERC721Metadata',
    ]);

    it('has a name', async function () {
      expect(await this.token.name()).to.be.equal('AsciiPunks');
    });

    it('has a symbol', async function () {
      expect(await this.token.symbol()).to.be.equal('ASC');
    });

    describe('token URI', function () {
      const baseURI = "https://api.com/v1/";
      beforeEach(async function () {
        await this.token.createPunk(firstTokenSeed, { from: owner, value: price});
      });

      it('returns api string by default', async function () {
        expect(await this.token.tokenURI(firstTokenId)).to.be.equal('https://api.asciipunks.com/punks/1');
      });

      it('reverts when queried for non existent token id', async function () {
        await expectRevert(
          this.token.tokenURI(nonExistentTokenId), 'ERC721: query for nonexistent token',
        );
      });

      describe('base URI', function () {
        it('base URI can be set', async function () {
          await this.token.setBaseURI(baseURI);
          expect(await this.token.baseURI()).to.equal(baseURI);
        });

        it('does not let base URI to be set by non-owner', async function () {
          await expectRevert(
            this.token.setBaseURI(baseURI, { from: approved }),
            'Ownable: caller is not the owner.'
          );
        });

        it('base URI is added as a prefix to the token URI', async function () {
          await this.token.setBaseURI(baseURI);
          expect(await this.token.tokenURI(firstTokenId)).to.be.equal(baseURI + firstTokenId.toString());
        });

        it('token URI can be changed by changing the base URI', async function () {
          await this.token.setBaseURI(baseURI);
          const newBaseURI = 'https://api.com/v2/';
          await this.token.setBaseURI(newBaseURI);
          expect(await this.token.tokenURI(firstTokenId)).to.be.equal(newBaseURI + firstTokenId.toString());
        });
      });
    });
  });
});
