// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IReserveManager
/// @notice Interface for TIPSC Reserve Manager (backing, ratio, value model).
interface IReserveManager {
    // --- State ---
    function totalReserves() external view returns (uint256);
    function totalTIPSCSupply() external view returns (uint256);
    function targetUnitValue() external view returns (uint256);
    function minReserveRatio() external view returns (uint256);

    // --- Hooks (called by TIPSC token) ---
    function onMint(uint256 amount) external;
    function onBurn(uint256 amount) external;

    // --- Governance-controlled setters ---
    function setTargetUnitValue(uint256 newValue) external;
    function setMinReserveRatio(uint256 newRatio) external;
    function updateReserves(uint256 newTotalReserves) external;

    // --- Views ---
    function getReserveRatio() external view returns (uint256);
    function isHealthy() external view returns (bool);

    // --- Events ---
    event GovernanceUpdated(address indexed oldGov, address indexed newGov);
    event TargetUnitValueUpdated(uint256 oldValue, uint256 newValue);
    event MinReserveRatioUpdated(uint256 oldRatio, uint256 newRatio);
    event ReservesUpdated(uint256 oldReserves, uint256 newReserves);
    event MintHook(uint256 amount, uint256 newSupply);
    event BurnHook(uint256 amount, uint256 newSupply);
}
