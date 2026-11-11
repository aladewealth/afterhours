// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title AfterHoursBoard
/// @notice Informal onchain subscriptions and Monday-gap calls for tokenized stocks on Base.
/// @dev No custody, no trading, no payouts. Calls are informational records only.
contract AfterHoursBoard {
    /// @notice Direction of a gap call relative to official NAV.
    /// @dev -1 = discount / gap down, 0 = flat, 1 = premium / gap up.
    int8 public constant DIR_DOWN = -1;
    int8 public constant DIR_FLAT = 0;
    int8 public constant DIR_UP = 1;

    uint256 public constant MAX_TICKER_LENGTH = 16;
    uint256 public constant MAX_NOTE_LENGTH = 280;

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

    uint256 public nextCallId = 1;
    mapping(address => mapping(bytes32 => bool)) public isSubscribed;
    mapping(address => uint256) public subscriptionCount;

    error EmptyTicker();
    error TickerTooLong();
    error NoteTooLong();
    error InvalidDirection();
    error AlreadySubscribed();

    function subscribe(string calldata ticker) external {
        bytes32 tickerHash = _tickerHash(ticker);
        if (isSubscribed[msg.sender][tickerHash]) revert AlreadySubscribed();
        isSubscribed[msg.sender][tickerHash] = true;
        subscriptionCount[msg.sender] += 1;
        emit Subscribed(msg.sender, tickerHash, ticker);
    }

    /// @notice Post a no-money, informational call on a ticker (e.g. the Monday gap).
    /// @param ticker Official tokenized-stock symbol, e.g. "AAPLc".
    /// @param direction -1 down, 0 flat, 1 up.
    /// @param note Optional short rationale, max 280 characters.
    function postCall(string calldata ticker, int8 direction, string calldata note) external {
        bytes32 tickerHash = _tickerHash(ticker);
        if (direction < DIR_DOWN || direction > DIR_UP) revert InvalidDirection();
        if (bytes(note).length > MAX_NOTE_LENGTH) revert NoteTooLong();

        uint256 callId = nextCallId;
        nextCallId = callId + 1;
        emit CallPosted(callId, msg.sender, tickerHash, ticker, direction, note, block.timestamp);
    }

    function _tickerHash(string calldata ticker) internal pure returns (bytes32) {
        bytes memory raw = bytes(ticker);
        if (raw.length == 0) revert EmptyTicker();
        if (raw.length > MAX_TICKER_LENGTH) revert TickerTooLong();
        return keccak256(raw);
    }
}
