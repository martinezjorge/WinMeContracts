// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

interface IUSDT {
    function allowance(address owner, address spender) external returns (uint256);
    function approve(address spender, uint value) external;
    function transfer(address _to, uint _value) external;
    function balanceOf(address _owner) external returns(uint256);
}