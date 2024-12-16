const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    const startupRegistrationAddress = "0xA7c8B0D74b68EF10511F27e97c379FB1651e1eD2";
    const marketplaceAddress = "0xE9061F92bA9A3D9ef3f4eb8456ac9E552B3Ff5C8";

    const startupRegistration = await hre.ethers.getContractAt("StartupRegistration", startupRegistrationAddress);

    const tx = await startupRegistration.registerStartup(
        "MyStartupToken",    // Token Name
        "MST",               // Token Symbol
        0,                  // Decimals
        1000000,             // Initial Supply
        marketplaceAddress,  // Marketplace Address
        hre.ethers.utils.parseEther("0.01") // Price per token in ETH
    );
    await tx.wait();

    console.log("Startup registered successfully!");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
