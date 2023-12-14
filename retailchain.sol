// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Retail { 
    struct Product {
        string name;
        uint256 price;
        uint256 stock;
    }   

    mapping(string => Product) public products;
    address payable owner;

    constructor() {
    owner = payable (msg.sender);
}

    function addProduct (string memory name, uint256 price, uint256 stock) public { 
        require(msg.sender == owner, "ONLY OWNER CAN ADD PRODUCT.");
        products[name] = Product(name, price, stock);
    }

    function updateProductPrice(string memory name, uint256 price) public {
        require(msg.sender == owner, "ONLY OWNER CAN UPDATE PRODUCT");
        require(products[name].price > 0, "PRODUCT DOESN'T EXIST.");
        products[name].price = price;
    }

    function updateProductStock(string memory name, uint256 stock) public {
        require(msg.sender == owner, "ONLY OWNER CAN ADD PRODUCT");
        require(products[name].stock > 0, "PRODUCT DOES NOT EXIST.");
        products[name].stock = stock;
    }

    function purchase(string memory name, uint256 quantity) public payable {
        require(msg.value == products[name].price * quantity, "Incorrect Payment Amount.");
        require(quantity <= products[name].stock, "NOT ENOUGH STOCK.");
        products[name].stock -= quantity;
    }

    function getProduct(string memory name) public view returns (string memory, uint256, uint256) {
        return (products[name].name, products[name].price, products[name].stock);
    }

   function grantAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can grant access.");
        owner = user;
    }

    function revokeAccess(address payable user) public {
        require(msg.sender ==  owner, "Only the owner can revoke the access.");
        require(user != owner, "Cannot revoke the access for the current owner.");
        owner = payable(msg.sender);
    }

    function destroy() public {
    require(msg.sender == owner, "Only the owner can destroy the contract.");
    uint256 balance = address(this).balance;
    payable(owner).transfer(balance);
    owner = payable(address(0));
}
}
