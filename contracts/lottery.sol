// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

error Lottery__NotEnoughETHEntered();

contract Lottery is VRFConsumerBaseV2 {
    uint256 private immutable i_entrancefee;
    address payable[] private s_players;

    event Lottery__PlayerEntered(address player, uint256 amount);

    constructor(address vrfCoordinatorV2, uint256 _entrancefee)
        VRFConsumerBaseV2(vrfCoordinatorV2)
    {
        i_entrancefee = _entrancefee;
    }

    function enterLottery() public payable {
        if (msg.value < i_entrancefee) {
            revert Lottery__NotEnoughETHEntered();
        }
        s_players.push(payable(msg.sender));
        emit Lottery__PlayerEntered(msg.sender, msg.value);
    }

    function requestRandomWinner() external {}

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
        internal
        override
    {}

    function getEntranceFee() public view returns (uint256) {
        return i_entrancefee;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }
}
