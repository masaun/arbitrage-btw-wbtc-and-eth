pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;


import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { ArbitrageHelper } from './ArbitrageHelper.sol';

import { ICErc20 } from "./compound/interfaces/ICErc20.sol";
import { ICEther } from "./compound/interfaces/ICEther.sol";
import { ICToken } from "./compound/interfaces/ICToken.sol";
import { IPriceFeed } from "./compound/interfaces/IPriceFeed.sol";
import { IComptroller } from "./compound/interfaces/IComptroller.sol";


/***
 * @notice - This contract that new version of ArbitrageurBtwSogurAndUniswap.sol
 **/
contract ArbitrageurBtwETHAndWBTC {

    /// Arbitrage ID
    uint8 public currentArbitrageId;

    ArbitrageHelper immutable arbitrageHelper;
    IERC20 immutable WBTC;

    address payable ARBITRAGE_HELPER;

    event MyLog(string, uint256);

    constructor(address payable _arbitrageHelper, address _wbtc) public {
        arbitrageHelper = ArbitrageHelper(_arbitrageHelper);
        WBTC = IERC20(_wbtc);

        ARBITRAGE_HELPER = _arbitrageHelper;
    }


    ///------------------------------------------------------------
    /// Workflow of arbitrage
    ///------------------------------------------------------------

    /***
     * @notice - Executor of flash swap for arbitrage profit (1: by using the flow of buying)
     **/
    function executeArbitrageByBuying(
        address payable userAddress, 
        uint WBTCAmount,
        address payable _cEther,
        address _cToken,
        address _comptroller,
        address _priceFeed,
        uint _underlyingDecimals
    ) public returns (bool) {
        /// Publish new arbitrage ID
        uint8 newArbitrageId = getNextArbitrageId();
        currentArbitrageId++;

        /// Borrow WBTC by using ETH as collateral. After that, Swap WBTC tokens for ETH on the Uniswap
        borrowWBTC(newArbitrageId, _cEther, _cToken, _comptroller, _priceFeed, _underlyingDecimals);
        swapWBTCForETH(userAddress, WBTCAmount);
    }

    /***
     * @notice - Executor of flash swap for arbitrage profit (2: by using the flow of selling)
     **/
    function executeArbitrageBySelling(address payable userAddress, uint WBTCAmount) public returns (bool) {
        /// Publish new arbitrage ID
        uint8 newArbitrageId = getNextArbitrageId();
        currentArbitrageId++;

        /// Sell WBTC tokens on the WBTC contract and Swap ETH for WBTC tokens on the Uniswap
        sellWBTC(newArbitrageId, WBTCAmount);
        swapETHForWBTC(userAddress, WBTCAmount);
    }


    ///------------------------------------------------------------
    /// Parts of workflow of arbitrage
    ///------------------------------------------------------------

    /***
     * @notice - Borrow WBTC by using ETH as collateral
     **/
    function borrowWBTC(
        uint arbitrageId, 
        address payable _cEther,
        address _cToken,
        address _comptroller,
        address _priceFeed,
        uint _underlyingDecimals
    ) public payable returns (uint _borrows) {
        /// At the 1st, ETH should be transferred from a user's wallet to this contract.
        ICEther cEth = ICEther(_cEther);
        ICErc20 cToken = ICErc20(_cToken);
        IComptroller comptroller = IComptroller(_comptroller);
        IPriceFeed priceFeed = IPriceFeed(_priceFeed);

        /// Supply ETH as collateral, get cETH in return
        cEth.mint.value(msg.value)();

        /// Enter the ETH market so you can borrow another type of asset
        address[] memory cTokens = new address[](1);
        cTokens[0] = _cEther;
        uint256[] memory errors = comptroller.enterMarkets(cTokens);
        if (errors[0] != 0) {
            revert("Comptroller.enterMarkets failed.");
        }

        /// Borrow WBTC (by using ETH as collateral)
        uint borrows = _borrowWBTC(cEth, cToken, comptroller, priceFeed, _underlyingDecimals);

        return borrows;
    }

    function _borrowWBTC(
        ICEther cEth,
        ICErc20 cToken,
        IComptroller comptroller,
        IPriceFeed priceFeed,
        uint _underlyingDecimals
    ) internal returns (uint _borrows) {
        // Get my account's total liquidity value in Compound
        (uint256 error, uint256 liquidity, uint256 shortfall) = comptroller
            .getAccountLiquidity(address(this));
        if (error != 0) {
            revert("Comptroller.getAccountLiquidity failed.");
        }
        require(shortfall == 0, "account underwater");
        require(liquidity > 0, "account has excess collateral");

        // Get the underlying price in USD from the Price Feed,
        // so we can find out the maximum amount of underlying we can borrow.
        uint256 underlyingPrice = priceFeed.getUnderlyingPrice(address(cToken));
        uint256 maxBorrowUnderlying = liquidity / underlyingPrice;

        // Borrowing near the max amount will result
        // in your account being liquidated instantly
        emit MyLog("Maximum underlying Borrow (borrow far less!)", maxBorrowUnderlying);

        // Borrow underlying
        uint256 numUnderlyingToBorrow = 10;

        // Borrow, check the underlying balance for this contract's address
        cToken.borrow(numUnderlyingToBorrow * 10**_underlyingDecimals);

        // Get the borrow balance
        uint256 borrows = cToken.borrowBalanceCurrent(address(this));
        emit MyLog("Current underlying borrow amount", borrows);

        return borrows;
    }
    

    /***
     * @notice - Swap the received WBTC back to ETH on Uniswap
     **/
    function swapWBTCForETH(address payable userAddress, uint WBTCAmount) public returns (bool) {
        /// Transfer WBTC tokens from this contract to the arbitrageHelper contract 
        //WBTCToken.transfer(ARBITRAGE_HELPER, WBTCAmount);

        /// Execute swap
        //arbitrageHelper.swapWBTCForETH(userAddress, WBTCAmount);
    }
    
    /***
     * @notice - Borrowing WBTC from Sögur's smart contract (by sending ETH to it)
     **/
    function repayWBTC(uint arbitrageId) public payable returns (bool) {}









    ///---------------------------------------------------------------------------///

    /***
     * @notice - Selling WBTC for ETH from Sögur's smart contract
     * @dev - Only specified the contract address of WBTCToken.sol as a "to" address in transferFrom() method of WBTCToken.sol
     **/
    function sellWBTC(uint arbitrageId, uint WBTCAmount) public returns (bool) {
        /// At the 1st, WBTC tokens should be transferred from a user's wallet to this contract by using transfer() method. 

        /// At the 2rd, operation below is executed
        WBTC.transferFrom(msg.sender, address(this), WBTCAmount); /// [Note]: WBTC exchanged with ETH via transferFrom() method
    }

    /***
     * @notice - Swap the received ETH back to WBTC on Uniswap (ETH - WBTC)
     **/    
    function swapETHForWBTC(address userAddress, uint WBTCAmount) public payable returns (bool) {
        /// Transfer ETH from this contract to the arbitrageHelper contract 
        //ARBITRAGE_HELPER.transfer(msg.value);

        /// Execute swap
        //arbitrageHelper.swapETHForWBTC(userAddress, WBTCAmount);
    }



    ///------------------------------------------------------------
    /// Internal functions
    ///------------------------------------------------------------



    ///------------------------------------------------------------
    /// Getter functions
    ///------------------------------------------------------------

    function getETHAmountWhenborrowWBTC(uint arbitrageId, address userAddress) public view returns (uint _ethAmountWhenborrowWBTC) {
        //return ethAmountWhenborrowWBTC[arbitrageId][userAddress];
    }    

    function getWBTCAmountWhenSellWBTC(uint arbitrageId, address userAddress) public view returns (uint _wbtcAmountWhenSellWBTC) {
        //return wbtcAmountWhenSellWBTC[arbitrageId][userAddress];
    }


    ///------------------------------------------------------------
    /// Private functions
    ///------------------------------------------------------------

    function getNextArbitrageId() private view returns (uint8 nextArbitrageId) {
        return currentArbitrageId + 1;
    }


}
