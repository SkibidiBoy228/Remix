// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;



contract Counter {

    uint256 private count;

    function increment() public {
        count++;
    }

    function decrement() public {
        require(count > 0, "Counter cannot be negative");
        count--;
    }

    function getCount() public view returns (uint256) {
        return count;
    }
}


contract TodoList {

    string[] private tasks;

    function addTask(string memory _task) public {
        tasks.push(_task);
    }

    function deleteTask(uint256 index) public {
        require(index < tasks.length, "Invalid index");

        tasks[index] = tasks[tasks.length - 1];
        tasks.pop();
    }

    function getTasks() public view returns (string[] memory) {
        return tasks;
    }
}


contract Shop {

    struct Product {
        string name;
        uint256 price;
    }

    Product[] public products;

    function addProduct(string memory _name, uint256 _price) public {
        products.push(Product(_name, _price));
    }

    function buyProduct(uint256 index) public payable {
        require(index < products.length, "Invalid product");
        require(msg.value >= products[index].price, "Not enough ETH");

    }

    function getProducts() public view returns (Product[] memory) {
        return products;
    }
}


contract SimpleVoting {

    struct Candidate {
        string name;
        uint256 votes;
    }

    Candidate[] public candidates;

    function addCandidate(string memory _name) public {
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint256 index) public {
        require(index < candidates.length, "Invalid candidate");
        candidates[index].votes++;
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }
}


contract Subscription {

    address public owner;
    uint256 public price;
    uint256 public duration = 30 days;

    mapping(address => uint256) public subscriptionEnd;

    constructor(uint256 _price) {
        owner = msg.sender;
        price = _price;
    }

    function subscribe() public payable {
        require(msg.value >= price, "Not enough ETH");

        subscriptionEnd[msg.sender] = block.timestamp + duration;
    }

    function isSubscribed(address user) public view returns (bool) {
        return subscriptionEnd[user] > block.timestamp;
    }

    function changePrice(uint256 _newPrice) public {
        require(msg.sender == owner, "Only owner");
        price = _newPrice;
    }
}

contract CommunityFunding {

    struct Project {
        string description;
        uint256 requiredAmount;
        uint256 votes;
        uint256 funds;
    }

    Project[] public projects;

    mapping(address => bool) public hasVoted;

    function proposeProject(string memory _description, uint256 _amount) public {
        projects.push(Project(_description, _amount, 0, 0));
    }

    function vote(uint256 index) public {
        require(index < projects.length, "Invalid project");
        require(!hasVoted[msg.sender], "Already voted");

        projects[index].votes++;
        hasVoted[msg.sender] = true;
    }

    function fundProject(uint256 index) public payable {
        require(index < projects.length, "Invalid project");

        projects[index].funds += msg.value;
    }

    function distributeFunds(uint256 index) view public {
        require(index < projects.length, "Invalid project");
        require(projects[index].votes > 0, "No votes");
        require(
            projects[index].funds >= projects[index].requiredAmount,
            "Not enough funds"
        );
    }

    function getProjects() public view returns (Project[] memory) {
        return projects;
    }
}
