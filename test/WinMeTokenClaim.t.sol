// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {WinMeTokenClaim} from "../src/WinMeTokenClaim.sol";

contract CounterTest is Test {
    WinMeTokenClaim public claimContract;

    function setUp() public {
        claimContract = new WinMeTokenClaim();
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
