// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ReserveManager.sol";

/// @title TIPSC Governance Contract
/// @notice Controls TIPSC monetary parameters, reserves, authorized roles and emergency actions.
contract Governance {
    // --- Roles ---
    address public council;          // Primary governance authority
    address public riskCommittee;    // Risk oversight role
    address public reserveManager;   // ReserveManager contract address
    address public tipscToken;       // TIPSC token contract address

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

    // --- Emergency State ---
    bool public emergencyPaused;

    // --- Modifiers ---
    modifier onlyCouncil() {
        require(msg.sender == council, "Governance: not council");
        _;
    }

    modifier onlyRiskCommittee() {
        require(msg.sender == riskCommittee, "Governance: not risk committee");
        _;
    }

    modifier onlyGovernanceRoles() {
        require(
            msg.sender == council || msg.sender == riskCommittee,
            "Governance: unauthorized"
        );
        _;
    }

    modifier notPaused() {
        require(!emergencyPaused, "Governance: emergency paused");
        _;
    }

    // --- Constructor ---
    constructor(
        address _council,
        address _riskCommittee,
        address _reserveManager
    ) {
        require(_council != address(0), "Governance: zero council");
        require(_riskCommittee != address(0), "Governance: zero risk committee");
        require(_reserveManager != address(0), "Governance: zero reserve manager");

        council = _council;
        riskCommittee = _riskCommittee;
        reserveManager = _reserveManager;
    }

    // ---------------------------------------------------------
    //  ROLE MANAGEMENT
    // ---------------------------------------------------------

    function setCouncil(address newCouncil) external onlyCouncil {
        require(newCouncil != address(0), "Governance: zero address");
        emit CouncilUpdated(council, newCouncil);
        council = newCouncil;
    }

    function setRiskCommittee(address newRC) external onlyCouncil {
        require(newRC != address(0), "Governance: zero address");
        emit RiskCommitteeUpdated(riskCommittee, newRC);
        riskCommittee = newRC;
    }

    function setReserveManager(address newRM) external onlyCouncil {
        require(newRM != address(0), "Governance: zero address");
        emit ReserveManagerUpdated(reserveManager, newRM);
        reserveManager = newRM;
    }

    function setTIPSCAddress(address newToken) external onlyCouncil {
        require(newToken != address(0), "Governance: zero address");
        emit TIPSCAddressUpdated(tipscToken, newToken);
        tipscToken = newToken;
    }

    // ---------------------------------------------------------
    //  TIPSC VALUE MODEL GOVERNANCE
    // ---------------------------------------------------------

    function setTargetUnitValue(uint256 newValue) external onlyGovernanceRoles notPaused {
        uint256 oldValue = ReserveManager(reserveManager).targetUnitValue();
        ReserveManager(reserveManager).setTargetUnitValue(newValue);
        emit TargetUnitValueChanged(oldValue, newValue);
    }

    function setMinReserveRatio(uint256 newRatio) external onlyGovernanceRoles notPaused {
        uint256 oldRatio = ReserveManager(reserveManager).minReserveRatio();
        ReserveManager(reserveManager).setMinReserveRatio(newRatio);
        emit MinReserveRatioChanged(oldRatio, newRatio);
    }

    function updateReserves(uint256 newTotalReserves) external onlyGovernanceRoles notPaused {
        uint256 oldReserves = ReserveManager(reserveManager).totalReserves();
        ReserveManager(reserveManager).updateReserves(newTotalReserves);
        emit ReservesUpdated(oldReserves, newTotalReserves);
    }

    // ---------------------------------------------------------
    //  EMERGENCY CONTROLS
    // ---------------------------------------------------------

    function activateEmergencyPause() external onlyGovernanceRoles {
        emergencyPaused = true;
        emit EmergencyPauseActivated(msg.sender);
    }

    function releaseEmergencyPause() external onlyCouncil {
        emergencyPaused = false;
        emit EmergencyPauseReleased(msg.sender);
    }
}
