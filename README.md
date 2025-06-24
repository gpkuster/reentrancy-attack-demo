# 🔓 Reentrancy Attack Demo in Solidity

This project demonstrates a **reentrancy vulnerability** in a smart contract written in Solidity, and how a malicious contract can exploit it to drain funds from the victim contract.

## 📁 Project Structure

- `VulnerableCryptoBank.sol`: A vulnerable contract that allows users to deposit and withdraw Ether. It is not protected against reentrancy attacks.
- `Attacker.sol`: A malicious contract that exploits the vulnerability in `VulnerableCryptoBank` to steal funds.
- `CEICryptoBank.sol`: An example of how to solve the vulnerability in `VulnerableCryptoBank.sol` by using CEI pattern.
- `GuardCryptoBank.sol`: Another example of how to solve the vulnerability in `VulnerableCryptoBank.sol` by using OpenZeppelin's `ReentrancyGuard`.
- `README.md`: This file.

## 🚨 Vulnerability Overview

The vulnerability lies in the `withdrawEther()` function in `CryptoBank.sol`, which follows this incorrect sequence:

1. **Check**: Ensures the user has enough balance.
2. **Interaction**: Sends Ether to the user via `call`.
3. **Effect**: Updates the user balance.

This order breaks the **Checks-Effects-Interactions (CEI)** pattern and makes it possible for a reentrancy attack to occur.

## 🧪 How the Attack Works

1. The attacker deposits some Ether into the `CryptoBank`.
2. The attacker calls `withdrawEther()`.
3. During the Ether transfer, the fallback function of the `Attacker` contract is triggered.
4. The fallback function re-enters `withdrawEther()` before the balance is updated.
5. This process repeats multiple times, draining the `CryptoBank` balance.

> The attack is **fully automatic** and does not require multiple manual calls — it's triggered recursively.

## ▶️ Deployment & Testing Steps (Remix)

1. Deploy `VulnerableCryptoBank` with any admin address and a max balance.
2. Send some Ether (e.g., 5 ETH) to `VulnerableCryptoBank` using the `depositEther()` function from different accounts.
3. Deploy `Attacker` with the address of the deployed `CryptoBank`.
4. Call `attack()` on `Attacker` with 1 ETH.
5. Observe how multiple withdrawals occur recursively.
6. Call `collectEther()` to transfer stolen Ether to the attacker's address.

## 🔒 How to Fix It

Follow the **CEI pattern** properly:
> Use `CEICryptoBank.sol` in the MaliciousContract

Or use OpenZeppelin's `ReentrancyGuard`:
> Use `GuardCryptoBank.sol` in the MaliciousContract

## 📚 Requirements
- Solidity ^0.8.0
- Remix IDE or Hardhat (optional)
- OpenZeppelin (only if you want to test `GuardCryptoBank.sol`)

## ⚠️ Disclaimer

This project is intended for educational and security research purposes only.
Do not deploy vulnerable contracts to production environments.