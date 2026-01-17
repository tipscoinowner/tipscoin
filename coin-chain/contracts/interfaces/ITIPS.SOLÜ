// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ITIPSC
/// @notice Interface for TIPSC token contract.
interface ITIPSC {
    // --- ERC20 Standard ---
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    // --- TIPSC Mint/Burn (controlled externally) ---
    function mintTo(address to, uint256 amount) external;
    function burnFrom(address from, uint256 amount) external;

    // --- Events ---
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
