// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IEmergencyGuardian
/// @notice Interface for TIPSC Emergency Guardian (global pause controller).
interface IEmergencyGuardian {
    // --- State ---
    function paused() external view returns (bool);

    // --- Actions ---
    function pause() external;
    function unpause() external;

    // --- Events ---
    event Paused(address indexed by);
    event Unpaused(address indexed by);
}
