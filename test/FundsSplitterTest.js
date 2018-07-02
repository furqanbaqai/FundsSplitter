var fundsSplitter = artifacts.require("./FundsSplitter.sol");
var nfundsSplitter;
contract('FundsSplitter', function (accounts) {
     beforeEach(function(done){
         nfundsSplitter = new fundsSplitter(accounts[1], accounts[2]);
         console.log('Instantiating funds transfer..');
         done();
     });
    it("[UT001] Check if FundsSplitter is getting instantiated", function () {
        assert.equal(typeof (nfundsSplitter), "object", "[UT001] Failure: Invalid object");        
    });       
    it("[UT002] Debiting units to the account", function () {        
        nfundsSplitter.splitFunds.sendTransaction({from: web3.eth.accounts[3], value: web3.toWei(2,'ether')}).then(txHash => {
            web3.eth.getTransaction(txHash).then(txRec => {
                var val = web3.fromWei(web3.eth.getTransaction(txRec).value.toString(10));
                assert.equal(val == '2', "[UT002] Account debited sucessfully");
            });
        });      
    });    
});