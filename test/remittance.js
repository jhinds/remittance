var Remittance = artifacts.require("./Remittance.sol");

contract('Remittance', (accounts) => {

  var owner = accounts[0];
  var exchangeAddress = accounts[1];
  var endRecipentAddress = accounts[2];
  var fee = 1;

  var contract;
  beforeEach(() => {
    return Remittance.new(exchangeAddress, endRecipentAddress, fee, {from: owner})
    .then((instance) => {
      contract = instance;
      // is this doing anything?
      exchangeAddress = exchangeAddress;
      endRecipentAddress = endRecipentAddress;
      fee = fee;
    });
  });

  it("should not be able to get funds without being unlocked with password", () => {
    const hash1 = "abc";
    const hash2 = "123";

    return contract.sendToExchange(hash1, {from: owner, value: 10})
    .then((_txn) => {
      return contract.decryptAccounts.call(hash2, {from: exchangeAddress})
      .then((amountSent) => {
        assert.equal(amountSent, 0, "Should not be able to claim funds with invalid password");
      });
    });
  });

  it("should allow the exhange to be able to convert the funds and send them elsewhere minus a cut", () => {
    const hash = "abc";

    return contract.sendToExchange(hash, {from: owner, value: 10})
    .then((_txn) => {
      return contract.decryptAccounts.call(hash, {from: exchangeAddress})
      .then((amountSent) => {
        assert.equal(amountSent, 10, "Did not get the full amount out of the wallet.");
      });
    });
  });
});
