const Dex = artifacts.require("Dex");
const Link = artifacts.require("Link");
const truffleAssert = require("truffle-assertions");

// should approve to enable deposits
// every test should be independent
contract("Dex", accounts => {
    it("should only be possible for owner ot add tokens", async () => {
        let dex = await Dex.deployed();
        let link = await Link.deployed();
        await truffleAssert.passes(
            dex.addToken(web3.utils.fromUtf8("LINK"), link.address, {from: accounts[0]})
        )
    })

    it("should allow deposits when the token is added and approved", async () => {
        let dex = await Dex.deployed();
        let link = await Link.deployed();
        await link.approve(dex.address, 500);
        dex.addToken(web3.utils.fromUtf8("LINK"), link.address);
        await dex.deposit(100, web3.utils.fromUtf8("LINK"));
        let balanceOfLink = await dex.balances(accounts[0], web3.utils.fromUtf8("LINK"));
        assert.equal(balanceOfLink.toNumber(), 100);
    })

    it("should not allow withdraws when address balance is not enough", async () => {
        let dex = await Dex.deployed();
        let link = await Link.deployed();
        await truffleAssert.reverts(
            dex.withdraw(500, web3.utils.fromUtf8("LINK"))
        )
    })

});