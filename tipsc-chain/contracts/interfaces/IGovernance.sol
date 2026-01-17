// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IGovernance
/// @notice Interface for TIPSC Governance (value model, reserves, emergency controls).
interface IGovernance {
    // --- Roles ---
    function council() external view returns (address);
    function riskCommittee() external view returns (address);
    function reserveManager() external view returns (address);
    function tipscToken() external view returns (address);

    // --- Governance actions ---
    function setCouncil(address newCouncil) external;
    function setRiskCommittee(address newRC) external;
    function setReserveManager(address newRM) external;
    function setTIPSCAddress(address newToken) external;

    // --- TIPSC Value Model ---
    function setTargetUnitValue(uint256 newValue) external;
    function setMinReserveRatio(uint256 newRatio) external;
    function updateReserves(uint256 newTotalReserves) external;

    // --- Emergency Controls ---
    function activateEmergencyPause() external;
    function releaseEmergencyPause() external;
    function emergencyPaused() external view returns (bool);

    // --- Events ---
    event CouncilUpdated(address indexed oldCouncil, address indexed newCouncil);
    event RiskCommitteeUpdated(address indexed oldRC, address indexed newRC);
    event ReserveManagerUpdated(address indexed oldRM, address indexed newRM);
    event TIPSCAddressUpdated(address indexed oldToken, address indexed newToken);

    event TargetUnitValueChanged(uint256 oldValue, uint256 newValue);
    event MinReserveRatioChanged(uint256 oldRatio, uint256 newRatio);
    event ReservesUpdated(uint256 oldReserves, uint256 newReserves);

    event EmergencyPauseActivated(address indexed triggeredBy);
    event EmergencyPauseReleased(address indexed triggeredBy);
}
