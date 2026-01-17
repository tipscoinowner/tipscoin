// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IAccessRegistry
/// @notice Interface for TIPSC Access Registry (role management).
interface IAccessRegistry {
    // --- Role Checks ---
    function isGovernance(address account) external view returns (bool);
    function isMintController(address account) external view returns (bool);
    function isGuardian(address account) external view returns (bool);
    function isTreasury(address account) external view returns (bool);

    // --- Owner ---
    function owner() external view returns (address);

    // --- Role Setters ---
    function setGovernance(address account, bool enabled) external;
    function setMintController(address account, bool enabled) external;
    function setGuardian(address account, bool enabled) external;
    function setTreasury(address account, bool enabled) external;

    // --- Owner Transfer ---
    function transferOwner(address newOwner) external;

    // --- Events ---
    event OwnerTransferred(address indexed oldOwner, address indexed newOwner);
    event GovernanceSet(address indexed account, bool enabled);
    event MintControllerSet(address indexed account, bool enabled);
    event GuardianSet(address indexed account, bool enabled);
    event TreasurySet(address indexed account, bool enabled);
}
