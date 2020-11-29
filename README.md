# Arbitrage between WBTC and ETH
## 【Introduction of Arbitrage between WBTC and ETH】
- This is a solidity smart contract that allows a user to get a opportunity to execute automatic arbitrage between WBTC and ETH.

&nbsp;

***

## 【Diagram of workflow】
![【Diagram】Arbitrageur btw WBTC and ETH (1)](https://user-images.githubusercontent.com/19357502/100541630-8bf59280-3288-11eb-9d17-8cda5b5d96e9.jpg)

&nbsp;

***

## 【Setup】
### ① Add `.env` file
- Based on `.env.example` , you add  `.env` file

<br>

### ② Install modules
```
$ npm install
```

<br>

### ③ Compile & migrate contracts (on Kovan testnet)
```
$ npm run migrate:kovan
```

<br>

### ④ Execute script (it's instead of testing)
```
$ npm run script:arbitrage
```

&nbsp;

***

## 【References】
- [Compound]:   
  - Deployed contract address (on Mainnet and Ropsten)    
    - Doc：https://compound.finance/docs#networks  
    - Github（Full）：https://github.com/compound-finance/compound-config/tree/master/networks  

  - compound-borrow-examples  
    https://github.com/compound-developers/compound-borrow-examples/blob/master/solidity-examples/MyContracts.sol  

  - Borrowing an ERC20 Token by using ETH as Collateral  
    https://medium.com/compound-finance/borrowing-assets-from-compound-quick-start-guide-f5e69af4b8f4   

  - [Workshop]：Lending & Borrowing Tokens on Compound from Solidity  
    https://www.youtube.com/watch?v=0H8pC1-ADoY  

<br>

- [Uniswap]:   
  - Flash Swap  
    https://uniswap.org/docs/v2/core-concepts/flash-swaps/  

  - Flash Swaps for developers  
    https://uniswap.org/docs/v2/smart-contract-integration/using-flash-swaps/     

  - ExampleFlashSwap.sol  
    https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/examples/ExampleFlashSwap.sol  

  - FlashSwap example  
    https://github.com/Austin-Williams/uniswap-flash-swapper  

<br>

- [Balancer]:  
  - Deployed addresses on Kovan  
    https://docs.balancer.finance/smart-contracts/addresses#kovan 

  - Doc  
    - interface   
      https://docs.balancer.finance/smart-contracts/interfaces  

    - on-chain registry (add pool pair)  
      https://docs.balancer.finance/smart-contracts/on-chain-registry#addpoolpair  
