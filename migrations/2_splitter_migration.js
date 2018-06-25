var FundsSplitter = artifacts.require("./FundsSplitter.sol");

module.exports = function(deployer) {
  console.log("Deploying Funds Splitter");
  deployer.deploy(FundsSplitter);
  deployer.deploy(FundsSplitter, {
    gas: 700000
  });
};