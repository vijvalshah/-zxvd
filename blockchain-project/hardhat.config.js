require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.20",
  networks: {
    hardhat: {
      chainId: 1337, // Default local Hardhat network ID
    },
    localhost: {
      url: "http://127.0.0.1:8545", // URL of the local Hardhat node
      accounts: ["0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e"],  // Replace <private-key> with your test account private key
    },
  },
  
};
