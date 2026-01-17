// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ReserveManager.sol";
import "./Governance.sol";

contract TIPSC {
    string public name = "TIPSC";
    string public symbol = "TIPSC";
    uint8 public decimals = 18;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    address public reserveManager;
    address public governance;
    address public treasury;

    modifier onlyGovernance() {
        require(msg.sender == governance, "Not governance");
        _;
    }

    modifier onlyTreasury() {
        require(msg.sender == treasury, "Not treasury");
        _;
    }

    constructor(address _reserveManager, address _governance, address _treasury) {
        reserveManager = _reserveManager;
        governance = _governance;
        treasury = _treasury;
    }

    function _mint(address to, uint256 amount) internal {
        totalSupply += amount;
        balanceOf[to] += amount;
        IReserveManager(reserveManager).onMint(amount);
    }

    function _burn(address from, uint256 amount) internal {
        require(balanceOf[from] >= amount, "Insufficient balance");
        balanceOf[from] -= amount;
        totalSupply -= amount;
        IReserveManager(reserveManager).onBurn(amount);
    }

    function treasuryMint(uint256 amount) external onlyTreasury {
        _mint(treasury, amount);
    }

    function treasuryBurn(uint256 amount) external onlyTreasury {
        _burn(treasury, amount);
    }
}

interface IReserveManager {
    function onMint(uint256 amount) external;
    function onBurn(uint256 amount) external;
}
