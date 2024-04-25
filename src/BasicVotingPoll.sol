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

    uint256 public s_pollCount;

    struct Poll{
        uint256 id;
        string question;
        string[] votingOptions;
        uint256 votingDuration;
        uint256 startAt;
        bool openedToRegisteredUsers;
    }

    /// @notice This function allows admins to create a poll
    /// @dev Only admins can create a poll
    /// @param _question The central query or subject matter that users will be voting on. 
    /// @param _votingOptions The possible choices or answers available for users to select when casting their votes.
    /// @param _votingDuration The designated period during which users can participate in the voting process.
    /// @param _openedToRegisteredUsers Whether or not un-registered users can vote
    function createPoll(
        string memory _question, 
        string[] memory _votingOptions, 
        uint256 _votingDuration,
        bool _openedToRegisteredUsers
    )external {
        require(s_administrators[msg.sender], "BasicVotingPoll: Only admins can create a poll");
        Poll memory poll = Poll({
            id: s_pollCount,
            question: _question,
            votingOptions: _votingOptions,
            startAt: block.timestamp,
            votingDuration: _votingDuration,
            openedToRegisteredUsers: _openedToRegisteredUsers
        });

        s_polls[s_pollCount] = poll;
        s_pollCount++;
    }

    function submitVote()external {}

    function retrieveVotingResult() external {}
}