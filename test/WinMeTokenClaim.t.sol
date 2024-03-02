// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {WinMeTokenEscrow} from "../src/WinMeEscrow.sol";

contract CounterTest is Test {
    WinMeTokenEscrow public claimContract;

    function setUp() public {
        claimContract = new WinMeTokenEscrow();
    }

    // function test_Increment() public {
    //     counter.increment();
    //     assertEq(counter.number(), 1);
    // }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
