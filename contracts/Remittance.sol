pragma solidity ^0.4.12;

contract Remittance {

    address public owner;
    address public exchangeAddress;
    address public endRecipent;

    uint public deadline;
    uint public deadlineLimit;
    // try to handle flat rate or percentage
    uint public fee;

    mapping(bytes32 => uint) public accounts;

    function Remittance(address _exchangeAddress, address _endRecipent, uint _fee) {
      owner = msg.sender;
      exchangeAddress = _exchangeAddress;
      endRecipent = _endRecipent;
      fee = _fee;
    }

    event MoneySentToExchange(address sender, address exhange, uint amount);
    event MoneyTakenOutOfExchange(address exchange, address recipent, uint amount);
    event DeadlinePassed();

    function deadlinePassed() returns (bool) {
      if (deadline > block.number) {
        DeadlinePassed();
        return true;
      } else {
        return false;
      }
    }

    function sendToExchange(bytes32 password1, bytes32 password2, uint _deadline) payable {
      require(msg.sender == owner);
      require(deadlineLimit <= _deadline);
      deadline = _deadline;
      bytes32 hash = keccak256(exchangeAddress, password1, password2);
      accounts[hash] = msg.value;
      MoneySentToExchange(msg.sender, exchangeAddress, msg.value);
    }

    function decryptAndSend(bytes32 password1, bytes32 password2) {
      require(msg.sender == exchangeAddress);
      bytes32 hash = keccak256(exchangeAddress, password1, password2);
      uint amount = accounts[hash];
      endRecipent.transfer(amount - fee);
      exchangeAddress.transfer(fee);
      MoneyTakenOutOfExchange(exchangeAddress, endRecipent, amount);
    }

 }
