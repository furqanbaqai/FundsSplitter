var FundsSplitter = artifacts.require("./FundsSplitter.sol");
var fundsSplitter;
contract('FundsSplitter', function (accounts) {
    var aliceAccount    = accounts[0];
    var bobAccount      = accounts[1];
    var carolAccount    = accounts[2];
    beforeEach(function(done){
         fundsSplitter = FundsSplitter.new({
            from: aliceAccount,
            gas: 1500000,
            gasvalue: 1
         });         
         done();
     });
    it("[UT001] Check if FundsSplitter is getting instantiated", function (done) {
        assert.equal(typeof (fundsSplitter), "object", "[UT001] Failure: Invalid object");        
        done();
    });       
    it("[UT002] Owner should be alice", function(done){        
        fundsSplitter.then(instance => {
            instance.owner().then(owner => {                
                assert(owner == aliceAccount, "[UT002] Failure: Invalid owner. Something is wrong here");
                done();
            });
        });
    });
    it("[UT003] Evenly Split funds and check if it is splitted successfully", function(done){
        fundsSplitter.then(instance => {
            /* Step#1: Check balances of bob and carol */
            var bobBalance;
            var carolBalance;

            instance.balances(bobAccount).then(balance => bobBalance = balance.toNumber());
            instance.balances(carolAccount).then(balance => carolBalance = balance.toNumber());
            bobBalance = (typeof bobBalance == 'undefined')? 0 : bobBalance;
            carolBalance = (typeof carolBalance == 'undefined') ? 0 : carolBalance;            
            return instance.splitFunds(bobAccount,carolAccount,{
                from: aliceAccount,
                value: web3.toWei(50, "wei")
            }).then(txHash => {
                // check balance of carol and bob
                var newBobBal;
                var newCarolBal;
                return instance.balances(bobAccount);
            }).then(newBal => {
                bobBalance = newBal - bobBalance;
                return instance.balances(carolAccount);
            }).then(newBal =>{
                carolBalance = newBal - carolBalance;                
                assert((bobBalance >= 25) && (carolBalance >= 25), "[UT003] Failure: Amount not debited in the accounts");                
                done();
            });
        });
    });
    /*it("[UT002] Debiting units to the account", function () {        
        nfundsSplitter.splitFunds.sendTransaction({from: web3.eth.accounts[3], value: web3.toWei(2,'ether')}).then(txHash => {
            web3.eth.getTransaction(txHash).then(txRec => {
                var val = web3.fromWei(web3.eth.getTransaction(txRec).value.toString(10));
                assert.equal(val == '2', "[UT002] Account debited sucessfully");
            });
        });      
    });*/    
});