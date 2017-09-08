pragma solidity ^0.4.12;

contract Remittance {

    address public owner;
    address public exchangeAddress;
    address public endRecipent;

    // try to handle flat rate or percentage
    uint public fee;

    mapping(bytes32 => uint) public accounts;
    mapping(address => uint) public unhashedAccounts;

    function Remittance(address _exchangeAddress, address _endRecipent, uint _fee) {
      owner = msg.sender;
      exchangeAddress = _exchangeAddress;
      endRecipent = _endRecipent;
      fee = _fee;
    }

    event MoneySentToExchange(address sender, address exhange, uint amount);
    event DecryptedFunds(address exchange, address recipent, uint decrytpedFunds, uint feesClaimed);
    event ContractKilled();

    // client needs to calculate hash "bytes32 hash = keccak256(exchangeAddress, password1, password2);"
    function sendToExchange(bytes32 hash) payable returns (uint amountSent) {
      require(msg.sender == owner);
      accounts[hash] = msg.value;
      MoneySentToExchange(msg.sender, exchangeAddress, msg.value);
      return msg.value;
    }

    // client needs to calculate hash "bytes32 hash = keccak256(exchangeAddress, password1, password2);"
    function decryptAccounts(bytes32 hash) returns (uint amountDecrypted) {
      require(msg.sender == exchangeAddress);
      uint amount = accounts[hash];
      accounts[hash] = 0;
      unhashedAccounts[endRecipent] = amount - fee;
      unhashedAccounts[exchangeAddress] = fee;
      DecryptedFunds(exchangeAddress, endRecipent, unhashedAccounts[endRecipent], unhashedAccounts[exchangeAddress]);
      return amount;
    }

    function withdraw() {
      msg.sender.transfer(unhashedAccounts[msg.sender]);
    }

    // to kill the contract
    function killContract() returns (bool){
      require(msg.sender == owner);
      suicide(owner);
      ContractKilled();
      return true;
    }

 }
