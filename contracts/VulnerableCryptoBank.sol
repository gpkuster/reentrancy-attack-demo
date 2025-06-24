// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract VulnerableCryptoBank {
    uint256 public maxBalance;
    address public admin;
    mapping(address => uint256) userBalance;

    event EtherDeposit(address user_, uint256 etheramount_);

    constructor(uint256 maxBalance_, address admin_) {
        maxBalance = maxBalance_;
        admin = admin_;
    }

    function depositEther() external payable {
        userBalance[msg.sender] += msg.value;
        emit EtherDeposit(msg.sender, msg.value);
    }

    function withdrawEther(uint256 amount_) external {
        require (userBalance[msg.sender] >= amount_, "Not enough balance");
        // Interacting with other smart contracts before updating the status is a vulnerability
        (bool success, ) = msg.sender.call{value: amount_}("");
        require(success, "The transaction could not be executed");
        
        // Validations to avoid underflow (will cause revert in ^0.8.0)
        if(userBalance[msg.sender] >= amount_) {
            userBalance[msg.sender] -= amount_;
        } else {
            userBalance[msg.sender] = 0;
        }
    }
}