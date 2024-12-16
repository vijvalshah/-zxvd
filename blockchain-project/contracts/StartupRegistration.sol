// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import the Token contract
import "./Token.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
}

interface IMarketplace {
    function listTokens(
        address token,
        uint256 amount,
        uint256 pricePerToken
    ) external;
}

contract StartupRegistration {
    // Events for logging
    event StartupRegistered(address indexed startupOwner, uint256 indexed startupId, string name, string symbol);
    event TokensMinted(address indexed startupOwner, uint256 indexed startupId, uint256 amount);

    // Struct to hold startup details
    struct Startup {
        string name;
        address tokenAddress; // Address of the token contract
        address owner;
        bool isRegistered;
    }

    // State variables
    uint256 public startupCount;
    mapping(uint256 => Startup) public startups;
    mapping(address => uint256[]) public ownerToStartups;

    // Register a new startup
    function registerStartup(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply,
        address _marketplace,
        uint256 _pricePerToken
    ) public {
        require(bytes(_name).length > 0, "Startup name required");
        require(bytes(_symbol).length > 0, "Startup symbol required");

        // Deploy a new Token contract for this startup
        Token token = new Token(_name, _symbol, _decimals, _initialSupply);

        // Increment the startup counter
        startupCount++;
        startups[startupCount] = Startup({
            name: _name,
            tokenAddress: address(token),
            owner: msg.sender,
            isRegistered: true
        });

        ownerToStartups[msg.sender].push(startupCount);

        emit StartupRegistered(msg.sender, startupCount, _name, _symbol);

        // Automatically list tokens on the marketplace
        token.approve(_marketplace, _initialSupply * (10 ** uint256(_decimals)));
        IMarketplace(_marketplace).listTokens(
            address(token), // Address of the token contract
            _initialSupply * (10 ** uint256(_decimals)), // Total supply of tokens
            _pricePerToken // Price per token
        );
    }

    // Mint new tokens for a registered startup
    function mintTokens(uint256 _startupId, uint256 _amount) public {
        require(_startupId > 0 && _startupId <= startupCount, "Invalid startup ID");
        Startup storage startup = startups[_startupId];
        require(msg.sender == startup.owner, "Only the startup owner can mint tokens");

        // Call the mint function of the token
            Token startupToken = Token(startup.tokenAddress);
        startupToken.mint(msg.sender, _amount);

        emit TokensMinted(msg.sender, _startupId, _amount);
    }

    // Get startup details
    function getStartupDetails(uint256 _startupId) public view returns (
        string memory name,
        address tokenAddress,
        address owner
    ) {
        require(_startupId > 0 && _startupId <= startupCount, "Invalid startup ID");
        Startup storage startup = startups[_startupId];
        return (startup.name, startup.tokenAddress, startup.owner);
    }
}
