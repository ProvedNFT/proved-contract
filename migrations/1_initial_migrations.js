const Proved = artifacts.require("Proved");

module.exports = function (deployer) {
  deployer.deploy(Proved, '0x0000000000000000000000000000000000000000');
};