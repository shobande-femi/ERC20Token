const OluwafemiShobandeToken = artifacts.require('./OluwafemiShobandeToken.sol');

module.exports = function(deployer) {
    deployer.deploy(OluwafemiShobandeToken);
}