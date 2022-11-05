// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

error Lottery__NotEnoughETHEntered();
error Lottery__TransferFailed();

contract Lottery is VRFConsumerBaseV2 {
    uint256 private immutable i_entrancefee;
    address payable[] private s_players;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint32 private immutable i_callbackGasLimit;

    address private s_recentWinner;

    event Lottery__PlayerEntered(address player, uint256 amount);
    event RequestedLotteryWinner(uint256 indexed requestId);
    event WinnerPicked(address indexed player);

    constructor(
        address vrfCoordinatorV2,
        uint256 _entrancefee,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_entrancefee = _entrancefee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterLottery() public payable {
        if (msg.value < i_entrancefee) {
            revert Lottery__NotEnoughETHEntered();
        }
        s_players.push(payable(msg.sender));
        emit Lottery__PlayerEntered(msg.sender, msg.value);
    }

    function requestRandomWinner() external {
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        emit RequestedLotteryWinner(requestId);
    }

    function fulfillRandomWords(
        uint256, /*requestId*/
        uint256[] memory randomWords
    ) internal override {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        if (!success) {
            revert Lottery__TransferFailed();
        }
        emit WinnerPicked(recentWinner);
    }

    function getEntranceFee() public view returns (uint256) {
        return i_entrancefee;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }

    function getRecentWinner() public view returns (address) {
        return s_recentWinner;
    }
}
