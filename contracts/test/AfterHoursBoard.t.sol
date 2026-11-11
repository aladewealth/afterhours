// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {AfterHoursBoard} from "../src/AfterHoursBoard.sol";

contract AfterHoursBoardTest is Test {
    AfterHoursBoard internal board;
    address internal alice = address(0xA11CE);
    address internal bob = address(0xB0B);

    event Subscribed(address indexed user, bytes32 indexed tickerHash, string ticker);
    event CallPosted(
        uint256 indexed callId,
        address indexed user,
        bytes32 indexed tickerHash,
        string ticker,
        int8 direction,
        string note,
        uint256 postedAt
    );

    function setUp() public {
        board = new AfterHoursBoard();
    }

    function _hash(string memory ticker) internal pure returns (bytes32) {
        return keccak256(bytes(ticker));
    }

    function testSubscribeEmitsAndRecords() public {
        vm.prank(alice);
        vm.expectEmit(true, true, false, true);
        emit Subscribed(alice, _hash("AAPLc"), "AAPLc");
        board.subscribe("AAPLc");

        assertTrue(board.isSubscribed(alice, _hash("AAPLc")));
        assertEq(board.subscriptionCount(alice), 1);
        assertFalse(board.isSubscribed(bob, _hash("AAPLc")));
    }

    function testSubscribeTwiceReverts() public {
        vm.startPrank(alice);
        board.subscribe("AAPLc");
        vm.expectRevert(AfterHoursBoard.AlreadySubscribed.selector);
        board.subscribe("AAPLc");
        vm.stopPrank();
    }

    function testSubscribeDifferentTickers() public {
        vm.startPrank(alice);
        board.subscribe("AAPLc");
        board.subscribe("TSLAc");
        vm.stopPrank();
        assertEq(board.subscriptionCount(alice), 2);
        assertTrue(board.isSubscribed(alice, _hash("TSLAc")));
    }

    function testSubscribeEmptyTickerReverts() public {
        vm.prank(alice);
        vm.expectRevert(AfterHoursBoard.EmptyTicker.selector);
        board.subscribe("");
    }

    function testSubscribeTickerTooLongReverts() public {
        vm.prank(alice);
        vm.expectRevert(AfterHoursBoard.TickerTooLong.selector);
        board.subscribe("THIS_TICKER_IS_WAY_TOO_LONG");
    }

    function testPostCallEmitsAndIncrementsId() public {
        vm.warp(1_700_000_000);
        vm.prank(alice);
        vm.expectEmit(true, true, true, true);
        emit CallPosted(1, alice, _hash("NVDAc"), "NVDAc", int8(1), "weekend premium holds", 1_700_000_000);
        board.postCall("NVDAc", 1, "weekend premium holds");
        assertEq(board.nextCallId(), 2);

        vm.prank(bob);
        vm.expectEmit(true, true, true, true);
        emit CallPosted(2, bob, _hash("NVDAc"), "NVDAc", int8(-1), "fades Monday", 1_700_000_000);
        board.postCall("NVDAc", -1, "fades Monday");
        assertEq(board.nextCallId(), 3);
    }

    function testPostCallAllowsFlatAndDoesNotRequireSubscribe() public {
        vm.prank(alice);
        board.postCall("MSFTc", 0, "");
        assertEq(board.nextCallId(), 2);
        assertFalse(board.isSubscribed(alice, _hash("MSFTc")));
    }

    function testPostCallInvalidDirectionReverts() public {
        vm.prank(alice);
        vm.expectRevert(AfterHoursBoard.InvalidDirection.selector);
        board.postCall("AAPLc", 2, "nope");
    }

    function testPostCallNoteTooLongReverts() public {
        bytes memory tooLong = new bytes(281);
        for (uint256 i = 0; i < 281; i++) {
            tooLong[i] = "a";
        }
        vm.prank(alice);
        vm.expectRevert(AfterHoursBoard.NoteTooLong.selector);
        board.postCall("AAPLc", 1, string(tooLong));
    }

    function testPostCallEmptyTickerReverts() public {
        vm.prank(alice);
        vm.expectRevert(AfterHoursBoard.EmptyTicker.selector);
        board.postCall("", 1, "x");
    }
}
