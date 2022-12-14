pragma solidity ^0.8.0;
// SPDX-License-Identifier: UNLICENSED.

contract VolcanoCoin {

    struct Payment {
        uint256 amount;
        address to;
    }

    mapping(address => Payment[]) payments;
    uint256 totalSupply;
    address owner;
    mapping(address => uint256) public balances;

    modifier onlyOwner {
        if (msg.sender == owner) {
            _;
        }
    }

    event TotalSupplyChanged(uint256 newSupply);
    event TokenTransfer(uint256 amount, address from, address to);

    constructor() {
        totalSupply = 10000;
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    function increaseSupply() onlyOwner public {
        totalSupply += 1000;
    }

    // We can get the sender address from msg.sender, having a variable 'from' where 
    // you can pass the address from we want to withdraw tokens would allow the users to withdraw from other users,
    // unless we have extra checks in place.
    function transfer(uint256 amount, address to) public {
        require(balances[msg.sender] >= amount, "user has not enough tokens");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        Payment memory newPayment = Payment(amount, to);

        Payment[] storage senderPayments = payments[msg.sender];
        senderPayments.push(newPayment);

        emit TokenTransfer(amount, msg.sender, to);
    }
}