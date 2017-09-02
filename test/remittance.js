var Remittance = artifacts.require("./Remittance.sol");

contract('Remittance', (accounts) => {

  var owner = accounts[0];
  var exchangeAddress = accounts[1];
  var endRecipentAddress = accounts[2];

  var contract;
  beforeEach(() => {
    return Remittance.new(exchangeAddress, endRecipentAddress, {from: owner})
    .then((instance) => {
      contract = instance;
      // is this doing anything?
      exchangeAddress = exchangeAddress;
      endRecipentAddress = endRecipentAddress;
    });
  });

  it("should allow owner to get funds back after a deadline", function() {

  });

  it("should not allow a deadline to go past a certain period", function() {

  });

  it("should be able to be killed", function(){

  });

  it("should not be able to get funds without being unlocked with password", function() {

  });

  it("should allow the exhange to be able to convert the funds and send them elsewhere minus a cut", function() {
    return contract.sendToExchange("abc", 123, 10, {from: owner});
  });

  it("should be able get balances", function() {

  });
});
