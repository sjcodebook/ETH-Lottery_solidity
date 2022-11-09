# ETH-Lottery_solidity
Lottery App on Ethereum

Website address => [https://eth-lottery-solidity.on.fleek.co](https://eth-lottery-solidity.on.fleek.co) or ipfs://Qmd5wpcHYsr7bvrrdT6yr4qocnkn5Ay7RvKQVwq8CWtLs9

Contract address on Goerli => [0x3c8dF6d99A6D993376757F4f434735313e15E2Dd](https://goerli.etherscan.io/address/0x3c8dF6d99A6D993376757F4f434735313e15E2Dd)

<img width="1440" alt="Screenshot 2022-11-09 at 4 50 33 PM" src="https://user-images.githubusercontent.com/45676934/200817205-285037f5-2cc6-4c7c-ac09-da8ac3b7070e.png">

- ***Compatible with only goerli and localhost***

# Usage

Deploy:

```
yarn hardhat deploy or yarn hardhat deploy --network goerli
```

## Testing

```
yarn hardhat test
```

### Test Coverage

```
yarn hardhat coverage
```

# Example .env file
```
ALCHEMY_MAINNET_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/xxxxxxxxx
GOERLI_RPC_URL=https://eth-goerli.g.alchemy.com/v2/xxxxxxxx
PRIVATE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ETHERSCAN_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
COINMARKETCAP_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
UPDATE_FRONT_END=true
```

Used ChainLink services => [vrf.chain.link](https://vrf.chain.link) and [keepers.chain.link](https://keepers.chain.link/new)





