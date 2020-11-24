pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import './ArbitrageHelper.sol';


/***
 * @notice - This contract that new version of ArbitrageurBtwSogurAndUniswap.sol
 **/
contract ArbitrageurBtwETHAndWBTC {

    /// Arbitrage ID
    uint public currentArbitrageId;

    /// Mapping for saving bought amount and sold amount
    mapping (uint => mapping (address => uint)) ethAmountWhenBuyWBTC;   /// Key: arbitrageId -> userAddress -> ETH amount that was transferred for buying WBTCToken
    mapping (uint => mapping (address => uint)) wbtcAmountWhenSellWBTC;  /// Key: arbitrageId -> userAddress -> WBTC amount that was transferred for selling WBTCToken

    ArbitrageHelper immutable arbitrageHelper;

    address payable ARBITRAGE_HELPER;

    constructor(address payable _arbitrageHelper) public {
        arbitrageHelper = ArbitrageHelper(_arbitrageHelper);

        ARBITRAGE_HELPER = _arbitrageHelper;
    }


    ///------------------------------------------------------------
    /// Workflow of arbitrage
    ///------------------------------------------------------------

    /***
     * @notice - Executor of flash swap for arbitrage profit (1: by using the flow of buying)
     **/
    function executeArbitrageByBuying(address payable userAddress, uint WBTCAmount) public returns (bool) {
        /// Publish new arbitrage ID
        uint newArbitrageId = getNextArbitrageId();
        currentArbitrageId++;

        /// Buy WBTC tokens on the WBTC contract and Swap WBTC tokens for ETH on the Uniswap
        buyWBTC(newArbitrageId);
        swapWBTCForETH(userAddress, WBTCAmount);
    }

    /***
     * @notice - Executor of flash swap for arbitrage profit (2: by using the flow of selling)
     **/
    function executeArbitrageBySelling(address payable userAddress, uint WBTCAmount) public returns (bool) {
        /// Publish new arbitrage ID
        uint newArbitrageId = getNextArbitrageId();
        currentArbitrageId++;

        /// Sell WBTC tokens on the WBTC contract and Swap ETH for WBTC tokens on the Uniswap
        sellWBTC(newArbitrageId, WBTCAmount);
        swapETHForWBTC(userAddress, WBTCAmount);
    }


    ///------------------------------------------------------------
    /// Parts of workflow of arbitrage (1st part)
    ///------------------------------------------------------------

    /***
     * @notice - Buying WBTC from Sögur's smart contract (by sending ETH to it)
     **/
    function buyWBTC(uint arbitrageId) public payable returns (bool) {
        /// At the 1st, ETH should be transferred from a user's wallet to this contract.

        /// At the 2rd, operations below are executed.
        WBTCToken.exchange();  /// Exchange ETH for WBTC.
        ethAmountWhenBuyWBTC[arbitrageId][msg.sender] = msg.value;  /// [Note]: Save the ETH amount that was transferred for buying WBTCToken 
    }

    /***
     * @notice - Swap the received WBTC back to ETH on Uniswap
     **/
    function swapWBTCForETH(address payable userAddress, uint WBTCAmount) public returns (bool) {
        /// Transfer WBTC tokens from this contract to the arbitrageHelper contract 
        WBTCToken.transfer(ARBITRAGE_HELPER, WBTCAmount);

        /// Execute swap
        arbitrageHelper.swapWBTCForETH(userAddress, WBTCAmount);
    }
    
    /***
     * @notice - Selling WBTC for ETH from Sögur's smart contract
     * @dev - Only specified the contract address of WBTCToken.sol as a "to" address in transferFrom() method of WBTCToken.sol
     **/
    function sellWBTC(uint arbitrageId, uint WBTCAmount) public returns (bool) {
        /// At the 1st, WBTC tokens should be transferred from a user's wallet to this contract by using transfer() method. 

        /// At the 2rd, operation below is executed
        WBTCToken.transferFrom(msg.sender, address(this), WBTCAmount); /// [Note]: WBTC exchanged with ETH via transferFrom() method
        wbtcAmountWhenSellWBTC[arbitrageId][msg.sender] = WBTCAmount;   /// [Note]: Save the WBTC amount that was transferred for selling WBTCToken
    }

    /***
     * @notice - Swap the received ETH back to WBTC on Uniswap (ETH - WBTC)
     **/    
    function swapETHForWBTC(address userAddress, uint WBTCAmount) public payable returns (bool) {
        /// Transfer ETH from this contract to the arbitrageHelper contract 
        ARBITRAGE_HELPER.transfer(msg.value);

        /// Execute swap
        arbitrageHelper.swapETHForWBTC(userAddress, WBTCAmount);
    }



    ///------------------------------------------------------------
    /// Internal functions
    ///------------------------------------------------------------



    ///------------------------------------------------------------
    /// Getter functions
    ///------------------------------------------------------------

    function getETHAmountWhenBuyWBTC(uint arbitrageId, address userAddress) public view returns (uint _ethAmountWhenBuyWBTC) {
        return ethAmountWhenBuyWBTC[arbitrageId][userAddress];
    }    

    function getWBTCAmountWhenSellWBTC(uint arbitrageId, address userAddress) public view returns (uint _wbtcAmountWhenSellWBTC) {
        return wbtcAmountWhenSellWBTC[arbitrageId][userAddress];
    }


    ///------------------------------------------------------------
    /// Private functions
    ///------------------------------------------------------------

    function getNextArbitrageId() private view returns (uint nextArbitrageId) {
        return currentArbitrageId.add(1);
    }


}
