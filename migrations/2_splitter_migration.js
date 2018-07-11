var FundsSplitter = artifacts.require("./FundsSplitter.sol");

module.exports = function(deployer, network, accounts) {
  console.log("Deploying Funds Splitter");
  deployer.deploy(FundsSplitter,{
    gas: 1500000
  });
  /*deployer.deploy(FundsSplitter, {
    gas: 700000
  });*/
};