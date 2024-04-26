let SUPERSGD = artifacts.require("SUPERSGD");
let PROPERTYA = artifacts.require("PROPERTYA");
let PROPERTYB = artifacts.require("PROPERTYB");
let PROPERTYD = artifacts.require("PROPERTYD");
let PROPERTYC = artifacts.require("PROPERTYC");
let SellOrderBook = artifacts.require("SellOrderBook");

module.exports = (deployer) => {
    // deployer.deploy(SUPERSGD);
    // deployer.deploy(PROPERTYA);
    // deployer.deploy(PROPERTYB);
    // deployer.deploy(PROPERTYD);
    // deployer.deploy(PROPERTYC);
    deployer.deploy(SellOrderBook, '0xfF9Dc5504EDc32d96268649B6e9B5cBdC5298C9C');
};