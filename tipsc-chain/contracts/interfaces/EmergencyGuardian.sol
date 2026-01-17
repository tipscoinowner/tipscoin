// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AccessRegistry.sol";

/// @title EmergencyGuardian
/// @notice Global pause / unpause controller for TIPSC token.
contract EmergencyGuardian {
    AccessRegistry public accessRegistry;
    bool public paused;

    event Paused(address indexed by);
    event Unpaused(address indexed by);

    modifier onlyGuardian() {
        require(accessRegistry.isGuardian(msg.sender), "Guardian: not guardian");
        _;
    }

    constructor(address _accessRegistry) {
        require(_accessRegistry != address(0), "Guardian: zero registry");
        accessRegistry = AccessRegistry(_accessRegistry);
    }

    function pause() external onlyGuardian {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() external onlyGuardian {
        paused = false;
        emit Unpaused(msg.sender);
    }
}
