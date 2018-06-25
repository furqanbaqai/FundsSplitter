var fundsSplitter = artifacts.require("./FundsSplitter.sol");

contract('FundsSplitter', function (accounts) {
    it("[UT001] Check if FundsSplitter is getting instantiated", function () {
        fundsSplitter.deployed().then((result) => {
            var obj = result.contract;
            assert.equal(typeof(obj),"object","[UT001] Failure: Invalid object");
        }).catch((err) => {
              consol.log("[UT001] Failure",err);
        });
    });
    it("[UT002] Reset all addresses",function(){
        fundsSplitter.deployed().then((result) =>{
            return result.reset();
        }).then(txObj => {
            assert.equal(txObj.receipt.status, '0x1', "[UT002] Failure: Invalid status code received. Status Code:" + txObj.receipt.status.toString());
        });
    });     
    it("[UT003] Seting bob address",function(){
        fundsSplitter.deployed().then((result) => {
            return result.setBobAdd(accounts[1]);
        }).then(txObj => {
            assert.equal(txObj.receipt.status, '0x1', "[UT003] Failure: Invalid status code received. Status Code:" + txObj.receipt.status.toString());
        });
    });
    it("[UT004] Seting carol address", function () {
        fundsSplitter.deployed().then((result) => {
            return result.setCarolAdd(accounts[2]);
        }).then(txObj => {
            assert.equal(txObj.receipt.status, '0x1', "[UT004] Failure: Invalid status code received. Status Code:" + txObj.receipt.status.toString());
        });
    });    
    it("[UT005] Debiting units to the account", function () {
        fundsSplitter.deployed().then((result) => {
            return result.debit(100);
        }).then(txObj => {
            assert.equal(txObj.receipt.status, '0x1', "[UT005] Failure: Invalid status code received. Status Code:" + txObj.receipt.status.toString());
        });
    });
    it("[UT006] Validating accounts", function () {
        fundsSplitter.deployed().then((result) => {
            return result.getBalance(accounts[1]);
        }).then((balance) =>{
            assert(balance, 50, "[UT006] Functional Failure. Amount should be 50 units");
        });
    });
});