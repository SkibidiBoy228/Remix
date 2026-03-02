// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;



interface IQuest {
    function startQuest(uint256 questId) external;
    function completeQuest(uint256 questId) external;
    function getReward(uint256 questId) external view returns (uint256);
}

contract QuestManager is IQuest {

    struct Quest {
        uint256 reward;
        uint256 requiredLevel;
        bool exists;
    }

    struct Player {
        uint256 level;
        uint256 experience;
        uint256 gold;
    }

    mapping(uint256 => Quest) public quests;
    mapping(address => Player) public players;
    mapping(address => mapping(uint256 => bool)) public activeQuests;

    constructor() {

        quests[1] = Quest(100, 1, true);
        quests[2] = Quest(300, 2, true);
    }

    function startQuest(uint256 questId) external override {
        require(quests[questId].exists, "Quest not found");
        require(players[msg.sender].level >= quests[questId].requiredLevel, "Level too low");

        activeQuests[msg.sender][questId] = true;
    }

    function completeQuest(uint256 questId) external override {
        require(activeQuests[msg.sender][questId], "Quest not active");

        uint256 reward = quests[questId].reward;

        players[msg.sender].gold += reward;
        players[msg.sender].experience += reward;

        if (players[msg.sender].experience >= players[msg.sender].level * 200) {
            players[msg.sender].level++;
            players[msg.sender].experience = 0;
        }

        activeQuests[msg.sender][questId] = false;
    }

    function getReward(uint256 questId) external view override returns (uint256) {
        return quests[questId].reward;
    }

    function registerPlayer() external {
        players[msg.sender] = Player(1, 0, 0);
    }
}


library ResourceUtils {

    function distributeEnergy(uint256 baseEnergy, uint256 level) internal pure returns (uint256) {
        return baseEnergy + (level * 10);
    }

    function upgradeCost(uint256 currentLevel) internal pure returns (uint256) {
        return currentLevel * 100;
    }

    function optimizeGold(uint256 gold, uint256 cost) internal pure returns (uint256) {
        require(gold >= cost, "Not enough gold");
        return gold - cost;
    }
}

contract ResourceManager {

    using ResourceUtils for uint256;

    struct Resources {
        uint256 energy;
        uint256 gold;
        uint256 level;
    }

    mapping(address => Resources) public playerResources;

    function register() external {
        playerResources[msg.sender] = Resources(100, 500, 1);
    }

    function getEnergy() external view returns (uint256) {
        Resources storage r = playerResources[msg.sender];
        return r.energy.distributeEnergy(r.level);
    }

    function upgradeLevel() external {
        Resources storage r = playerResources[msg.sender];

        uint256 cost = r.level.upgradeCost();
        r.gold = r.gold.optimizeGold(cost);
        r.level++;
    }
}



contract WarriorGuild {

    mapping(address => bool) public registered;

    function registerWarrior() public {
        registered[msg.sender] = true;
    }

    modifier onlyWarrior() {
        require(registered[msg.sender], "Not registered");
        _;
    }
}

contract Knight is WarriorGuild {

    function attack() public view onlyWarrior returns (uint256) {
        return 50; 
    }
}

contract Mage is WarriorGuild {

    function attack() public view onlyWarrior returns (uint256) {
        return 30 + (block.timestamp % 20);
    }
}

contract Assassin is WarriorGuild {

    function attack() public view onlyWarrior returns (uint256) {
        return 70; 
    }
}
