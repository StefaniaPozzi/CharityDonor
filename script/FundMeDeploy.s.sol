//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract FundMeDeploy is Script {
    function run() external returns (FundMe) {
        HelperConfig hc = new HelperConfig();
        address priceFeed = hc.activeNetConfig();
        vm.startBroadcast();
        // FundMeTest is the ** msg.sender ** of this contract, the caller
        FundMe fundme = new FundMe(priceFeed);
        vm.stopBroadcast();
        return fundme;
    }
}
