const CarTracker = artifacts.require("CarTracker");

module.exports = function (deployer) {
  deployer.deploy(CarTracker);
};
