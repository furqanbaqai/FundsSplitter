var FundsSplitter = artifacts.require("./FundsSplitter.sol");

module.exports = function(deployer, network, accounts) {
  console.log("Deploying Funds Splitter");
  deployer.deploy(FundsSplitter, accounts[1], accounts[2],{
    gas: 1000000
  });
  /*deployer.deploy(FundsSplitter, {
    gas: 700000
  });*/
};