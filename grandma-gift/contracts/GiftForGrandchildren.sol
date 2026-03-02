// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract GiftForGrandchildren {

    address public grandma;
    uint256 public totalDeposit;
    uint256 public giftPerChild;

    struct Grandchild {
        uint256 birthday;
        bool withdrawn;
        bool exists;
    }

    mapping(address => Grandchild) public grandchildren;
    address[] public grandchildList;

    event Withdraw(address indexed grandchild, uint256 amount);

    modifier onlyGrandma() {
        require(msg.sender == grandma, "Not grandma");
        _;
    }

    modifier onlyGrandchild() {
        require(grandchildren[msg.sender].exists, "Not grandchild");
        _;
    }

    constructor() payable {
        grandma = msg.sender;
    }

    function addGrandchild(address _addr, uint256 _birthday) external onlyGrandma {
        require(!grandchildren[_addr].exists, "Already added");

        grandchildren[_addr] = Grandchild(_birthday, false, true);
        grandchildList.push(_addr);
    }

    function deposit() external payable onlyGrandma {
        require(grandchildList.length > 0, "No grandchildren");

        totalDeposit += msg.value;
        giftPerChild = totalDeposit / grandchildList.length;
    }

    function withdraw() external onlyGrandchild {
        Grandchild storage g = grandchildren[msg.sender];

        require(!g.withdrawn, "Already withdrawn");
        require(block.timestamp >= g.birthday, "Too early");

        g.withdrawn = true;

        payable(msg.sender).transfer(giftPerChild);

        emit Withdraw(msg.sender, giftPerChild);
    }

    function getGrandchildrenCount() external view returns (uint256) {
        return grandchildList.length;
    }
}
