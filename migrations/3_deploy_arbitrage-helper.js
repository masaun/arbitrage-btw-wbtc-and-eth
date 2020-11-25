const ArbitrageHelper = artifacts.require("ArbitrageHelper");

//@dev - Import from exported file
var contractAddressList = require('./addressesList/contractAddress/contractAddress.js');
var tokenAddressList = require('./addressesList/tokenAddress/tokenAddress.js');
var walletAddressList = require('./addressesList/walletAddress/walletAddress.js');

const _uniswapV2Factory = contractAddressList["Ropsten"]["Uniswap"]["UniswapV2Factory"];
const _uniswapV2Router02 = contractAddressList["Ropsten"]["Uniswap"]["UniswapV2Router02"];
const _wbtc = tokenAddressList["Ropsten"]["WBTC"];

module.exports = async function (deployer) {
    deployer.deploy(ArbitrageHelper, _uniswapV2Factory, _uniswapV2Router02, _wbtc);
};
