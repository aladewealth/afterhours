// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {AfterHoursBoard} from "../src/AfterHoursBoard.sol";

/// @dev Not used in phase 1. Do not run until a deployer wallet is available.
contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
        AfterHoursBoard board = new AfterHoursBoard();
        vm.stopBroadcast();
        console.log("AfterHoursBoard", address(board));
    }
}
