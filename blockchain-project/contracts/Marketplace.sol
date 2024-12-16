// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Marketplace {
    event TokenListed(address indexed seller, address indexed token, uint256 amount, uint256 pricePerToken);
    event TokenPurchased(address indexed buyer, address indexed token, uint256 amount, uint256 price);

    struct Listing {
        address seller;
        address token;
        uint256 amount;
        uint256 pricePerToken;
    }

    uint256 public listingCount;
    mapping(uint256 => Listing) public listings;

    // Mapped balances to simulate token balances (mocked)
    mapping(address => mapping(address => uint256)) public simulatedBalances;

    // List tokens in the marketplace
    function listTokens(
        address _token,
        uint256 _amount,
        uint256 _pricePerToken
    ) public {
        require(_amount > 0, "Amount must be greater than 0");
        require(_pricePerToken > 0, "Price must be greater than 0");

        // Simulating the transfer of tokens to the marketplace (mocked)
        simulatedBalances[msg.sender][_token] += _amount;

        listingCount++;
        listings[listingCount] = Listing({
            seller: msg.sender,
            token: _token,
            amount: _amount,
            pricePerToken: _pricePerToken
        });

        emit TokenListed(msg.sender, _token, _amount, _pricePerToken);
    }

    // Simulate buying tokens from the marketplace
    function buyTokens(uint256 _listingId, uint256 _amount) public payable {
        Listing storage listing = listings[_listingId];
        require(listing.amount >= _amount, "Not enough tokens available");
        uint256 totalPrice = _amount * listing.pricePerToken;
        require(msg.value == totalPrice, "Incorrect payment amount");

        // Simulate a "token" transfer by updating balances (without actually transferring ERC20 tokens)
        simulatedBalances[listing.seller][listing.token] -= _amount;
        simulatedBalances[msg.sender][listing.token] += _amount;

        // Simulate payment transfer to the seller (mocked)
        payable(listing.seller).transfer(msg.value);

        listing.amount -= _amount;
        emit TokenPurchased(msg.sender, listing.token, _amount, msg.value);

        if (listing.amount == 0) {
            delete listings[_listingId];
        }
    }

    // Function to check balance of a user for a specific token (mocked)
    function balanceOf(address _user, address _token) public view returns (uint256) {
        return simulatedBalances[_user][_token];
    }

    // Get listing details by listingId
    function getListing(uint256 _listingId) public view returns (address seller, address token, uint256 amount, uint256 pricePerToken) {
        Listing memory listing = listings[_listingId];
        return (listing.seller, listing.token, listing.amount, listing.pricePerToken);
    }
}
