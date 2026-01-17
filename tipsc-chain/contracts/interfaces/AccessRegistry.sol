// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AccessRegistry
/// @notice Central role registry for TIPSC ecosystem.
contract AccessRegistry {
    address public owner;

    mapping(address => bool) public isGovernance;
    mapping(address => bool) public isMintController;
    mapping(address => bool) public isGuardian;
    mapping(address => bool) public isTreasury;

    event OwnerTransferred(address indexed oldOwner, address indexed newOwner);
    event GovernanceSet(address indexed account, bool enabled);
    event MintControllerSet(address indexed account, bool enabled);
    event GuardianSet(address indexed account, bool enabled);
    event TreasurySet(address indexed account, bool enabled);

    modifier onlyOwner() {
        require(msg.sender == owner, "AccessRegistry: not owner");
        _;
    }

    constructor(address _owner) {
        require(_owner != address(0), "AccessRegistry: zero owner");
        owner = _owner;
    }

    function transferOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "AccessRegistry: zero owner");
        emit OwnerTransferred(owner, newOwner);
        owner = newOwner;
    }

    function setGovernance(address account, bool enabled) external onlyOwner {
        isGovernance[account] = enabled;
        emit GovernanceSet(account, enabled);
    }

    function setMintController(address account, bool enabled) external onlyOwner {
        isMintController[account] = enabled;
        emit MintControllerSet(account, enabled);
    }

    function setGuardian(address account, bool enabled) external onlyOwner {
        isGuardian[account] = enabled;
        emit GuardianSet(account, enabled);
    }

    function setTreasury(address account, bool enabled) external onlyOwner {
        isTreasury[account] = enabled;
        emit TreasurySet(account, enabled);
    }
}
