pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import './uniswapV2/uniswap-v2-periphery/libraries/UniswapV2Library.sol';

import './uniswapV2/uniswap-v2-core/interfaces/IUniswapV2Factory.sol';
import './uniswapV2/uniswap-v2-core/interfaces/IUniswapV2Pair.sol';
import './uniswapV2/uniswap-v2-periphery/interfaces/IUniswapV2Router02.sol';
import './uniswapV2/uniswap-v2-periphery/interfaces/IERC20.sol';
import './uniswapV2/uniswap-v2-periphery/interfaces/IWETH.sol';


/***
 * @notice - This contract that ...
 **/
contract ArbitrageHelper {

    IUniswapV2Router02 public uniswapV2Router02;
    IUniswapV2Factory immutable uniswapV2Factory;
    IWETH immutable WETH;
    IERC20 immutable WBTC;

    address immutable WBTC_ADDRESS;

    constructor(address _uniswapV2Factory, address _uniswapV2Router02, address _wbtc) public {
        uniswapV2Factory = IUniswapV2Factory(_uniswapV2Factory);
        uniswapV2Router02 = IUniswapV2Router02(_uniswapV2Router02);
        WETH = IWETH(uniswapV2Router02.WETH());
        WBTC = IERC20(_wbtc);

        WBTC_ADDRESS = _wbtc;
    }


    ///------------------------------------------------------------
    /// General Swap on Uniswap v2
    ///------------------------------------------------------------

    /* @notice - Swap WBTC for ETH (Swap between WBTC - ETH)
     *         - Ref: https://soliditydeveloper.com/uniswap2
     **/
    function swapWBTCForETH(address payable userAddress, uint WBTCAmount) public payable {
        /// [ToDo]: Should add a method for compute ETHAmountMin
        uint ETHAmountMin;

        /// amountOutMin must be retrieved from an oracle of some kind
        uint deadline = block.timestamp + 15; // using 'now' for convenience, for mainnet pass deadline from frontend!
        uint amountIn = WBTCAmount;
        uint amountOutMin = ETHAmountMin;  /// [Todo]: Retrieve a minimum amount of ETH
        uniswapV2Router02.swapExactTokensForETH(amountIn, amountOutMin, getPathForWBTCToETH(), address(this), deadline);

        /// refund leftover WBTCToken to user
        // (bool success,) = msg.sender.call{ value: address(this).balance }("");
        // require(success, "refund failed");
    }
  
    function getEstimatedWBTCForETH(uint ETHAmount) public view returns (uint[] memory) {
        uint amountOut = ETHAmount;
        return uniswapV2Router02.getAmountsIn(amountOut, getPathForWBTCToETH());
    }

    function getPathForWBTCToETH() private view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = WBTC_ADDRESS;
        path[1] = uniswapV2Router02.WETH();
        
        return path;
    }


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
