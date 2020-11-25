const ArbitrageurBtwWBTCAndETH = artifacts.require("ArbitrageurBtwWBTCAndETH");
const ArbitrageHelper = artifacts.require("ArbitrageHelper");

//@dev - Import from exported file
var contractAddressList = require('./addressesList/contractAddress/contractAddress.js');
var tokenAddressList = require('./addressesList/tokenAddress/tokenAddress.js');
var walletAddressList = require('./addressesList/walletAddress/walletAddress.js');

const _arbitrageHelper = ArbitrageHelper.address;
const _wbtc = tokenAddressList["Ropsten"]["WBTC"];

module.exports = function(deployer) {
    deployer.deploy(ArbitrageurBtwWBTCAndETH, _arbitrageHelper, _wbtc);
};
