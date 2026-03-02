
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Voting {

    struct Poll {
        string question;
        string[] options;
        uint[] votes;
        bool exists;
    }

    uint public pollCount;
    mapping(uint => Poll) private polls;
    mapping(uint => mapping(address => bool)) public hasVoted;

    function createPoll(string memory _question, string[] memory _options) public {
        require(_options.length > 1, "Minimum 2 options");

        Poll storage p = polls[pollCount];
        p.question = _question;
        p.options = _options;
        p.votes = new uint[](_options.length);
        p.exists = true;

        pollCount++;
    }

    function vote(uint _pollId, uint _optionIndex) public {
        require(polls[_pollId].exists, "Poll not found");
        require(!hasVoted[_pollId][msg.sender], "Already voted");
        require(_optionIndex < polls[_pollId].options.length, "Invalid option");

        polls[_pollId].votes[_optionIndex]++;
        hasVoted[_pollId][msg.sender] = true;
    }

    function getVotes(uint _pollId) public view returns (uint[] memory) {
        return polls[_pollId].votes;
    }

    function getOptions(uint _pollId) public view returns (string[] memory) {
        return polls[_pollId].options;
    }

    function getQuestion(uint _pollId) public view returns (string memory) {
        return polls[_pollId].question;
    }
}