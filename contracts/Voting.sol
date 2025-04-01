// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    struct Proposal {
        string description;
        uint256 voteCount;
        bool executed;
    }
    
    mapping(address => bool) public voters;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    
    Proposal[] public proposals;
    
    event ProposalCreated(uint256 proposalId, string description);
    event VoteCasted(uint256 proposalId, address voter);
    event ProposalExecuted(uint256 proposalId);
    
    constructor() Ownable(msg.sender) {}
    
    function addVoter(address voter) external onlyOwner {
        voters[voter] = true;
    }
    
    function createProposal(string memory description) external onlyOwner returns (uint256) {
        proposals.push(Proposal({
            description: description,
            voteCount: 0,
            executed: false
        }));
        uint256 proposalId = proposals.length - 1;
        emit ProposalCreated(proposalId, description);
        return proposalId;
    }
    
    function vote(uint256 proposalId) external {
        require(voters[msg.sender], "Not a voter");
        require(!hasVoted[proposalId][msg.sender], "Already voted");
        require(!proposals[proposalId].executed, "Proposal already executed");
        
        hasVoted[proposalId][msg.sender] = true;
        proposals[proposalId].voteCount++;
        emit VoteCasted(proposalId, msg.sender);
    }
    
    function executeProposal(uint256 proposalId) external onlyOwner {
        require(!proposals[proposalId].executed, "Already executed");
        proposals[proposalId].executed = true;
        emit ProposalExecuted(proposalId);
    }
}
