// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract GuardCryptoBank is ReentrancyGuard {

    mapping(address => uint256) public userBalance;

    event EtherDeposit(address user, uint256 amount);

    function depositEther() external payable {
        userBalance[msg.sender] += msg.value;
        emit EtherDeposit(msg.sender, msg.value);
    }

    function withdrawEther(uint256 amount) external nonReentrant {
        // Even if we are using nonReentrant, using CEI pattern is a good practice
        // Check
        require(userBalance[msg.sender] >= amount, "Insufficient balance"); 

        // Effects
        userBalance[msg.sender] -= amount;

        // Interactions
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    receive() external payable {}
}
