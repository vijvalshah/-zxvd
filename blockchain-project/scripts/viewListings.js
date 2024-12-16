const hre = require("hardhat");

async function main() {
    const marketplaceAddress = "0xE9061F92bA9A3D9ef3f4eb8456ac9E552B3Ff5C8";
    const marketplace = await hre.ethers.getContractAt("Marketplace", marketplaceAddress);

    const listingId = 1; // Example: Listing ID 1
    const listing = await marketplace.getListing(listingId);

    console.log("Listing Details:", {
        seller: listing.seller,
        token: listing.token,
        amount: listing.amount.toString(),
        pricePerToken: hre.ethers.utils.formatEther(listing.pricePerToken)
    });
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
