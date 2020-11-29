// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import { BPool } from "./BPool.sol";

interface BFactory {

    function isBPool(address b) external view returns (bool);
    function newBPool() external returns (BPool);

}
