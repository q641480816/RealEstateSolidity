let SUPERSGD = artifacts.require("SUPERSGD");
let PROPERTYA = artifacts.require("PROPERTYA");
let PROPERTYB = artifacts.require("PROPERTYB");
let PROPERTYD = artifacts.require("PROPERTYD");
let PROPERTYC = artifacts.require("PROPERTYC");
let SellOrderBook = artifacts.require("SellOrderBook");

module.exports = (deployer) => {
    deployer.deploy(SUPERSGD)
        .then(() => deployer.deploy(SellOrderBook, SUPERSGD.address));
    deployer.deploy(PROPERTYA, 1255, "0x0000000000000000000000000000000000000000");
    deployer.deploy(PROPERTYB, 998, "0x0000000000000000000000000000000000000000");
    deployer.deploy(PROPERTYC,825, "0x0000000000000000000000000000000000000000");
    deployer.deploy(PROPERTYD, 1053, "0x2b51D2469fE60691eB47A2b588583cf3595E3e51");    
};