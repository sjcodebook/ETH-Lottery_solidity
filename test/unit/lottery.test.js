const { assert, expect } = require("chai")
const { network, deployments, ethers } = require("hardhat")
const { developmentChains, networkConfig } = require("../../helper-hardhat-config")

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("Lottery Unit Tests", function () {
          let lottery, lotteryContract, vrfCoordinatorV2Mock, lotteryEntranceFee, interval, player

          beforeEach(async () => {
              accounts = await ethers.getSigners()
              //   deployer = accounts[0]
              player = accounts[1]
              await deployments.fixture(["mocks", "lottery"])
              vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock")
              lotteryContract = await ethers.getContract("Lottery")
              lottery = lotteryContract.connect(player)
              lotteryEntranceFee = await lottery.getEntranceFee()
              interval = await lottery.getInterval()
          })

          describe("constructor", function () {
              it("initializes the lottery correctly", async () => {
                  const lotteryState = (await lottery.getLotteryState()).toString()
                  assert.equal(lotteryState, "0")
                  assert.equal(
                      interval.toString(),
                      networkConfig[network.config.chainId]["keepersUpdateInterval"]
                  )
              })
          })

          describe("enterLottery", function () {
              it("reverts when you don't pay enough", async () => {
                  await expect(lottery.enterLottery()).to.be.revertedWith(
                      // is reverted when not paid enough or lottery is not open
                      "Lottery__NotEnoughETHEntered"
                  )
              })
              it("records player when they enter", async () => {
                  await lottery.enterLottery({ value: lotteryEntranceFee })
                  const contractPlayer = await lottery.getPlayer(0)
                  assert.equal(player.address, contractPlayer)
              })
              it("emits event on enter", async () => {
                  await expect(lottery.enterLottery({ value: lotteryEntranceFee })).to.emit(
                      // emits LotteryEnter event if entered to index player(s) address
                      lottery,
                      "Lottery__PlayerEntered"
                  )
              })
              it("doesn't allow entrance when lottery is calculating", async () => {
                  await lottery.enterLottery({ value: lotteryEntranceFee })
                  await network.provider.send("evm_increaseTime", [interval.toNumber() + 1])
                  await network.provider.request({ method: "evm_mine", params: [] })
                  await lottery.performUpkeep([]) // changes the state to calculating for our comparison below
                  await expect(
                      lottery.enterLottery({ value: lotteryEntranceFee })
                  ).to.be.revertedWith(
                      // is reverted as lottery is calculating
                      "Lottery__LotteryNotOpen"
                  )
              })
          })
      })
