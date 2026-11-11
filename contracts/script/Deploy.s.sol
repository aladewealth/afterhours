// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {AfterHoursBoard} from "../src/AfterHoursBoard.sol";

/// @notice Deploys AfterHoursBoard to Base Sepolia.
/// @dev The contract is permissionless (no owner/admin). Do not pass a private key on the CLI;
///      set PRIVATE_KEY in a gitignored env file and let Forge read ETH_PRIVATE_KEY.
contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
        AfterHoursBoard board = new AfterHoursBoard();
        vm.stopBroadcast();
        console.log("AfterHoursBoard", address(board));
    }
}
