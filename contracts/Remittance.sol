pragma solidity ^0.4.12;

contract Remittance {

    address public owner;
    address public exchangeAddress;
    address public endRecipent;

    uint public deadline;
    uint public deadlineLimit;
    uint public fee;

    mapping(bytes32 => uint) public accounts;

    function Remittance(address _exchangeAddress, address _endRecipent) {
      owner = msg.sender;
      exchangeAddress = _exchangeAddress;
      endRecipent = _endRecipent;
    }

    event MoneySentToExchange();
    event MoneyConverted();
    event MoneyLeavingExhange();
    event DeadlinePassed();

    function deadlinePassed() returns (bool) {
      if (deadline > block.number) {
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
      MoneySentToExchange();
    }

    function decryptAndSend(bytes32 password1, bytes32 password2) {
      require(msg.sender == exchangeAddress);
      bytes32 hash = keccak256(exchangeAddress, password1, password2);
      endRecipent.transfer(accounts[hash] - fee);
      exchangeAddress.transfer(fee);
    }

    function toBytes(address a) constant returns (bytes b){
     assembly {
          let m := mload(0x40)
          mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, a))
          mstore(0x40, add(m, 52))
          b := m
     }
}

}
