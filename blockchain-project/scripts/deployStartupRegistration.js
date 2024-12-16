const hre = require("hardhat");

async function main() {
    const StartupRegistration = await hre.ethers.getContractFactory("StartupRegistration");
    const startupRegistration = await StartupRegistration.deploy();
    await startupRegistration.deployed();

    console.log("StartupRegistration deployed to:", startupRegistration.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
