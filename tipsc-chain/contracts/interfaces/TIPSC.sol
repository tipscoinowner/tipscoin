// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AccessRegistry.sol";
import "./ReserveManager.sol";
import "./EmergencyGuardian.sol";

/// @title TIPSC Token
/// @notice Native institutional asset of TIPSPAY ecosystem.
contract TIPSC {
    string public name = "TIPSPAY Stable Coin";
    string public symbol = "TIPSC";
    uint8 public decimals = 18;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    AccessRegistry public accessRegistry;
    ReserveManager public reserveManager;
    EmergencyGuardian public guardian;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier notPaused() {
        require(!guardian.paused(), "TIPSC: paused");
        _;
    }

    modifier onlyMintController() {
        require(accessRegistry.isMintController(msg.sender), "TIPSC: not minter");
        _;
    }

    constructor(
        address _accessRegistry,
        address _reserveManager,
        address _guardian
    ) {
        require(_accessRegistry != address(0), "TIPSC: zero registry");
        require(_reserveManager != address(0), "TIPSC: zero reserve");
        require(_guardian != address(0), "TIPSC: zero guardian");

        accessRegistry = AccessRegistry(_accessRegistry);
        reserveManager = ReserveManager(_reserveManager);
        guardian = EmergencyGuardian(_guardian);
    }

    // --- ERC20 core ---

    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "TIPSC: zero to");
        require(balanceOf[from] >= amount, "TIPSC: balance");
        unchecked {
            balanceOf[from] -= amount;
            balanceOf[to] += amount;
        }
        emit Transfer(from, to, amount);
    }

    function transfer(address to, uint256 amount) external notPaused returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external notPaused returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external notPaused returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= amount, "TIPSC: allowance");
        if (allowed != type(uint256).max) {
            allowance[from][msg.sender] = allowed - amount;
        }
        _transfer(from, to, amount);
        return true;
    }

    // --- Mint / Burn (via MintController) ---

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "TIPSC: zero to");
        totalSupply += amount;
        balanceOf[to] += amount;
        reserveManager.onMint(amount);
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        require(balanceOf[from] >= amount, "TIPSC: balance");
        balanceOf[from] -= amount;
        totalSupply -= amount;
        reserveManager.onBurn(amount);
        emit Transfer(from, address(0), amount);
    }

    function mintTo(address to, uint256 amount) external onlyMintController notPaused {
        _mint(to, amount);
    }

    function burnFrom(address from, uint256 amount) external onlyMintController notPaused {
        _burn(from, amount);
    }
}
