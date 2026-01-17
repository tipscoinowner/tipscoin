// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IMintController
/// @notice Interface for TIPSC Mint Controller.
interface IMintController {
    // --- Mint / Burn ---
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;

    // --- Limits ---
    function setDailyMintLimit(address account, uint256 limit) external;
    function dailyMintLimit(address account) external view returns (uint256);
    function mintedToday(address account) external view returns (uint256);
    function lastMintDay(address account) external view returns (uint256);

    // --- Events ---
    event MintRequested(address indexed requester, address indexed to, uint256 amount);
    event BurnRequested(address indexed requester, address indexed from, uint256 amount);
    event DailyMintLimitSet(address indexed account, uint256 limit);
}
