// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface Comptroller {
    function claimComp(address holder) external;
}
