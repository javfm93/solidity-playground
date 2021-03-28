const Dex = artifacts.require("Dex");
const Link = artifacts.require("Link");
const truffleAssert = require("truffle-assertions");

// should approve to enable deposits
// every test should be independent
contract("Dex", (accounts) => {
  let dexContract, linkContract, linkSymbol;
  beforeEach(async () => {
    dexContract = await Dex.new();
    linkContract = await Link.new();
    linkSymbol = web3.utils.fromUtf8(linkContract.symbol);
  });

  it("should only be possible for owner ot add tokens", async () => {
    await truffleAssert.passes(
      dexContract.addToken(linkSymbol, linkContract.address)
    );
  });

  describe("Given an approved and added token to the dex", () => {
    beforeEach(async () => {
      await linkContract.approve(dexContract.address, 500);
      dexContract.addToken(linkSymbol, linkContract.address);
    });

    it("should allow deposits", async () => {
      await dexContract.deposit(100, linkSymbol);
      let balanceOfLink = await dexContract.balances(accounts[0], linkSymbol);
      assert.equal(balanceOfLink.toNumber(), 100);
    });

    it("should not allow withdraws when address balance is not enough", async () => {
      await dexContract.deposit(100, linkSymbol);
      await truffleAssert.reverts(dexContract.withdraw(500, linkSymbol));
    });
  });
});
