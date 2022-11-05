// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

error Lottery__NotEnoughETHEntered();

contract Lottery {
    uint256 private immutable i_entrancefee;
    address payable[] private s_players;

    constructor(uint256 _entrancefee) {
        i_entrancefee = _entrancefee;
    }

    function enterLottery() public payable {
        if (msg.value < i_entrancefee) {
            revert Lottery__NotEnoughETHEntered();
        }
        s_players.push(payable(msg.sender));
    }

    function getEntranceFee() public view returns (uint256) {
        return i_entrancefee;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }
}
