// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TIPSC Reserve Manager
/// @notice Tracks backing reserves, TIPSC supply and enforces reserve ratio & target value.
contract ReserveManager {
    address public governance;

    // Abstracted backing units (could represent basket, off-chain mirrored, etc.)
    uint256 public totalReserves;

    // Total TIPSC supply (kept in sync via hooks)
    uint256 public totalTIPSCSupply;

    // Target unit value for 1 TIPSC (e.g. 1e18 = 1.0)
    uint256 public targetUnitValue;

    // Minimum reserve ratio (e.g. 1e18 = 100%)
    uint256 public minReserveRatio;

    event GovernanceUpdated(address indexed oldGov, address indexed newGov);
    event TargetUnitValueUpdated(uint256 oldValue, uint256 newValue);
    event MinReserveRatioUpdated(uint256 oldRatio, uint256 newRatio);
    event ReservesUpdated(uint256 oldReserves, uint256 newReserves);
    event MintHook(uint256 amount, uint256 newSupply);
    event BurnHook(uint256 amount, uint256 newSupply);

    modifier onlyGovernance() {
        require(msg.sender == governance, "ReserveManager: not governance");
        _;
    }

    constructor(
        address _governance,
        uint256 _targetUnitValue,
        uint256 _minReserveRatio
    ) {
        require(_governance != address(0), "ReserveManager: zero governance");
        governance = _governance;
        targetUnitValue = _targetUnitValue;
        minReserveRatio = _minReserveRatio;
    }

    // --- Governance control ---

    function setGovernance(address newGovernance) external onlyGovernance {
        require(newGovernance != address(0), "ReserveManager: zero governance");
        emit GovernanceUpdated(governance, newGovernance);
        governance = newGovernance;
    }

    function setTargetUnitValue(uint256 newValue) external onlyGovernance {
        emit TargetUnitValueUpdated(targetUnitValue, newValue);
        targetUnitValue = newValue;
    }

    function setMinReserveRatio(uint256 newRatio) external onlyGovernance {
        emit MinReserveRatioUpdated(minReserveRatio, newRatio);
        minReserveRatio = newRatio;
    }

    function updateReserves(uint256 newTotalReserves) external onlyGovernance {
        emit ReservesUpdated(totalReserves, newTotalReserves);
        totalReserves = newTotalReserves;
    }

    // --- TIPSC supply hooks (called by TIPSC token contract) ---

    function onMint(uint256 amount) external {
        // In a stricter model, you’d restrict this to the TIPSC contract address.
        totalTIPSCSupply += amount;
        emit MintHook(amount, totalTIPSCSupply);
    }

    function onBurn(uint256 amount) external {
        require(totalTIPSCSupply >= amount, "ReserveManager: supply underflow");
        totalTIPSCSupply -= amount;
        emit BurnHook(amount, totalTIPSCSupply);
    }

    // --- View helpers ---

    /// @notice Returns reserve ratio in 1e18 precision (reserves / supply).
    function getReserveRatio() public view returns (uint256) {
        if (totalTIPSCSupply == 0) return type(uint256).max;
        return (totalReserves * 1e18) / totalTIPSCSupply;
    }

    /// @notice Returns true if reserve ratio >= minReserveRatio.
    function isHealthy() external view returns (bool) {
        return getReserveRatio() >= minReserveRatio;
    }
}
