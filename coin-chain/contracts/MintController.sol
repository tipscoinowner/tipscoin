// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AccessRegistry.sol";
import "./TIPSC.sol";

/// @title MintController
/// @notice Controls who can request TIPSC mint/burn and enforces simple limits.
contract MintController {
    AccessRegistry public accessRegistry;
    TIPSC public tipsc;

    // Optional simple daily limit structure (can be extended later)
    mapping(address => uint256) public dailyMintLimit;
    mapping(address => uint256) public mintedToday;
    mapping(address => uint256) public lastMintDay;

    event MintRequested(address indexed requester, address indexed to, uint256 amount);
    event BurnRequested(address indexed requester, address indexed from, uint256 amount);
    event DailyMintLimitSet(address indexed account, uint256 limit);

    modifier onlyGovernance() {
        require(accessRegistry.isGovernance(msg.sender), "MintController: not governance");
        _;
    }

    modifier onlyMintController() {
        require(accessRegistry.isMintController(msg.sender), "MintController: not mint controller");
        _;
    }

    constructor(address _accessRegistry, address _tipsc) {
        require(_accessRegistry != address(0), "MintController: zero registry");
        require(_tipsc != address(0), "MintController: zero TIPSC");
        accessRegistry = AccessRegistry(_accessRegistry);
        tipsc = TIPSC(_tipsc);
    }

    function setDailyMintLimit(address account, uint256 limit) external onlyGovernance {
        dailyMintLimit[account] = limit;
        emit DailyMintLimitSet(account, limit);
    }

    function _updateMintWindow(address requester, uint256 amount) internal {
        uint256 day = block.timestamp / 1 days;
        if (lastMintDay[requester] != day) {
            lastMintDay[requester] = day;
            mintedToday[requester] = 0;
        }
        uint256 newTotal = mintedToday[requester] + amount;
        uint256 limit = dailyMintLimit[requester];
        if (limit > 0) {
            require(newTotal <= limit, "MintController: daily limit");
        }
        mintedToday[requester] = newTotal;
    }

    function mint(address to, uint256 amount) external onlyMintController {
        _updateMintWindow(msg.sender, amount);
        tipsc.mintTo(to, amount);
        emit MintRequested(msg.sender, to, amount);
    }

    function burn(address from, uint256 amount) external onlyMintController {
        tipsc.burnFrom(from, amount);
        emit BurnRequested(msg.sender, from, amount);
    }
}
