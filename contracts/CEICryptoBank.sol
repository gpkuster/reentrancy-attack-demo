// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CEICryptoBank {

    mapping(address => uint256) public userBalance;

    event EtherDeposit(address user, uint256 amount);

    function depositEther() external payable {
        userBalance[msg.sender] += msg.value;
        emit EtherDeposit(msg.sender, msg.value);
    }

    function withdrawEther(uint256 amount) external {
        // Check
        require(userBalance[msg.sender] >= amount, "Insufficient balance");

        // ✅ Effects before external interactions
        userBalance[msg.sender] -= amount;

        // ✅ External interaction after updating contract's status
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    receive() external payable {}
}
