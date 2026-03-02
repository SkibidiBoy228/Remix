// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract ProductStorage {

    struct Product {
        string name;
        string description;
        address owner;
        uint256 createdAt;
        string imageUrl;
    }

    Product[] public products;

    event ProductAdded(
        string name,
        string description,
        address owner,
        uint256 createdAt,
        string imageUrl
    );

    function addProduct(
        string memory _name,
        string memory _description,
        string memory _imageUrl
    ) public {

        Product memory newProduct = Product({
            name: _name,
            description: _description,
            owner: msg.sender,
            createdAt: block.timestamp,
            imageUrl: _imageUrl
        });

        products.push(newProduct);

        emit ProductAdded(
            _name,
            _description,
            msg.sender,
            block.timestamp,
            _imageUrl
        );
    }

    function getProductsCount() public view returns (uint256) {
        return products.length;
    }

    function getProduct(uint256 index) public view returns (
        string memory name,
        string memory description,
        address owner,
        uint256 createdAt,
        string memory imageUrl
    ) {
        Product memory p = products[index];
        return (
            p.name,
            p.description,
            p.owner,
            p.createdAt,
            p.imageUrl
        );
    }

    function getAllProducts() public view returns (Product[] memory) {
        return products;
    }
}