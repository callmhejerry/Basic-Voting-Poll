// SPDX-Liecense-Identifier:MIT
pragma solidity 0.8.19;

/// @title A Basic Voting Poll contract
/// @author Chinedu Jeremiah
/// @notice The Contract will allow users to participate in voting for predefined options, view voting results in real-time, and ensure transparency and integrity in the voting process.
contract BasicVotingPoll {

    constructor (address[] memory admins){
        s_pollCount = 0;
        for (uint i =0; i < admins.length; i++){
            s_administrators[admins[i]] = true;
        }
    }

    mapping(address=>bool) public s_administrators;
    mapping(address=>bool) public s_registeredUsers;
    mapping(uint256=>Poll) public s_polls;
    mapping(uint256=>mapping(address=>uint)) public s_pollVotes;

    uint256 public s_pollCount;

    struct Poll{
        uint256 id;
        string question;
        string[] votingOptions;
        uint256 votingDuration;
        uint256 startAt;
        bool openedToOtherUsers;
    }

    /// @notice This function allows admins to create a poll
    /// @dev Only admins can create a poll
    /// @param _question The central query or subject matter that users will be voting on. 
    /// @param _votingOptions The possible choices or answers available for users to select when casting their votes.
    /// @param _votingDuration The designated period during which users can participate in the voting process.
    /// @param _openedToOtherUsers Whether or not un-registered users can vote
    function createPoll(
        string memory _question, 
        string[] memory _votingOptions, 
        uint256 _votingDuration,
        bool _openedToOtherUsers
    )external {
        require(s_administrators[msg.sender], "BasicVotingPoll: Only admins can create a poll");
        Poll memory poll = Poll({
            id: s_pollCount,
            question: _question,
            votingOptions: _votingOptions,
            startAt: block.timestamp,
            votingDuration: _votingDuration,
            openedToOtherUsers: _openedToOtherUsers
        });

        s_polls[s_pollCount] = poll;
        s_pollCount++;
    }

    /// @notice Allows users to vote in a poll
    /// @param _pollId Id of the poll
    /// @param _votingOption Option to vote for
    function submitVote(
        uint256 _pollId,
        uint256 _votingOption
    )external validatePollId(_pollId){
        Poll memory poll = s_polls[_pollId];
    
        require(block.timestamp >= poll.startAt && block.timestamp < poll.startAt + poll.votingDuration,
                "BasicVotingPoll: Poll has ended, cannot submit vote");
        if(!poll.openedToOtherUsers){
            require(s_registeredUsers[msg.sender], "BasicVotingPoll: Only registered users can vote");
        }
        s_pollVotes[_pollId][msg.sender] = _votingOption;
    }

    function retrieveVotingResult() external {}

    modifier validatePollId(uint256 _pollId){
        require(_pollId < s_pollCount, "BasicVotingPoll: Invalid PollId");
        require(s_polls[_pollId].startAt != 0, "BasicVotingPoll: This poll is inactive or has ended");
        _;
    }
}