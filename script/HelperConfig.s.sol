//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

/**
 * 1. Deploy mocks when we are on Anvil
 * 2. Keep track of contract address across different chains (there is no way to connect them?)
 */
contract HelperConfig is Script {
    NetworkConfig public activeNetConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetConfig = getSepoliaNetConfig();
        } else {
            activeNetConfig = getOrCreateAnvilNetConfig();
        }
    }

    function getSepoliaNetConfig() public pure returns (NetworkConfig memory) {
        //price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilNetConfig() public returns (NetworkConfig memory) {
        //do not deploy it more than once
        if (activeNetConfig.priceFeed != address(0)) {
            return activeNetConfig;
        }
        //1.deploy mocks
        //2.return address
        vm.startBroadcast();
        MockV3Aggregator ma = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(ma)
        });
        return anvilConfig;
    }
}
