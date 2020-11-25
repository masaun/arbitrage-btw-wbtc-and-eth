pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

/***
 * @notice - This contract that ...
 **/
contract ArbitrageHelper {

    constructor() public {}


    ///------------------------------------------------------------
    /// General Swap on Uniswap v2
    ///------------------------------------------------------------


    /***
     * @notice - important to receive ETH
     **/
    receive() payable external {}


    ///------------------------------------------------------------
    /// Parts of workflow of arbitrage (2nd part)
    ///------------------------------------------------------------

    /***
     * @notice - Transfer ETH that includes profit amount and initial amount into a user.
     **/
    // function transferETHIncludeProfitAmountAndInitialAmounToUser(address payable userAddress) public returns (bool) {
    //     uint ETHBalanceOfContract = address(this).balance;
    //     userAddress.transfer(ETHBalanceOfContract);  /// Transfer ETH from this contract to userAddress's wallet
    // }

    /***
     * @notice - Transfer WBTC tokens that includes profit amount and initial amount into a user.
     **/
    // function transferWBTCIncludeProfitAmountAndInitialAmounToUser(address userAddress) public returns (bool) {
    //     uint WBTCBalanceOfContract = WBTCToken.balanceOf(address(this));
    //     WBTCToken.transfer(userAddress, WBTCBalanceOfContract);  /// Transfer WBTC from this contract to userAddress's wallet        
    // }



    ///------------------------------------------------------------
    /// Internal functions
    ///------------------------------------------------------------



    ///------------------------------------------------------------
    /// Getter functions
    ///------------------------------------------------------------
 


    ///------------------------------------------------------------
    /// Private functions
    ///------------------------------------------------------------


}
