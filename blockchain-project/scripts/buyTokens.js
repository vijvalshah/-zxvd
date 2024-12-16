const hre = require("hardhat");

async function main() {
    // Get the buyer account (use the first account in the local node)
    const [buyer] = await hre.ethers.getSigners();

    // Address of the Marketplace contract deployed on your local network
    const marketplaceAddress = "0xE9061F92bA9A3D9ef3f4eb8456ac9E552B3Ff5C8"; // Replace with actual deployed address
    const marketplace = await hre.ethers.getContractAt("Marketplace", marketplaceAddress);

    // Hardcoded values for the listing and amount
    const listingId = 1; // Hardcoded Listing ID
    const amount = 2; // Hardcoded token amount (e.g., 2 tokens)
    
    // Fetch the listing details using the getListing function from your Marketplace contract
    const listingDetails = await marketplace.getListing(listingId);
    const pricePerToken = listingDetails.pricePerToken;
    const totalPrice = pricePerToken.mul(amount); // Calculate the total price for the tokens

    console.log(`Listing ID: ${listingId}`);
    console.log(`Buying ${amount} tokens for ${hre.ethers.utils.formatEther(totalPrice)} ETH...`);

    // Perform the token purchase
    const tx = await marketplace.connect(buyer).buyTokens(listingId, amount, { value: totalPrice });
    await tx.wait(); // Wait for the transaction to be mined

    console.log("Tokens purchased successfully!");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
