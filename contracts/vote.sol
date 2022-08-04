// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract vote {
    
    address public owner;
    string public electionName;

    struct Candidate {
        string name;
        uint voteCount;
    }

    struct Voter {
        bool nftValidity;
        bool voted;
        uint candidateIndex;
    }

    mapping(uint => Voter) voters; // key is the nft token
    Candidate[] public candidates;
    uint public maxVotes;
    uint public maxCandidates;
    uint public votesMade;

    // constructor

    constructor(string memory _name, uint _maxVotes, uint _maxCandidates) public {
        owner = msg.sender;
        electionName = _name;
        maxVotes = _maxVotes;
        maxCandidates = _maxCandidates;
        votesMade = 0;
    }

    function addCandidate(string memory _name) isOwner public {
        require(candidates.length <= maxCandidates);
        candidates.push(Candidate(_name, 0));
    }

    function authorize(uint _nft) isOwner public {
        // verification of the nft token assigned to msg.sender
            // verification might include is the nft token present on the nft chain and is it expired or not

        // after verification we can assign nftValidity to be true
        voters[_nft].nftValidity = true;
    }

    function castVote(uint _nft, uint _candidateIndex) public {
        require(!voters[_nft].voted);
        require(voters[_nft].nftValidity);
        require(_candidateIndex < maxCandidates);
        require(votesMade < maxVotes);

        voters[_nft].candidateIndex = _candidateIndex;
        voters[_nft].voted = true;

        candidates[_candidateIndex].voteCount += 1;
        votesMade += 1;
        
    }

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }
}
