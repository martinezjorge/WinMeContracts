// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IWinMeToken {
    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function mint(address account, uint256 amount) external;
}