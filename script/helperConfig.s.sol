//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mockAggregatorV3.sol";

contract helperConfig is Script {
    // if we are on local anvil,we deploy mocks
    // otherwise grab the existing address from live network

    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    struct networkConfig {
        address pricefeed;
    }
    networkConfig public active;

    constructor() {
        if (block.chainid == 11155111) {
            active = getSepoliaConfig();
        } else {
            active = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (networkConfig memory) {
        networkConfig memory sepolia = networkConfig(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return sepolia;
    }

    function getAnvilConfig() public returns (networkConfig memory) {
        if (active.pricefeed != address(0)) {
            return active;
        }
        // deploy mocks, return mock addresses
        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(DECIMAL, INITIAL_PRICE);
        vm.stopBroadcast();
        networkConfig memory anvil = networkConfig(address(mock));
        return anvil;
    }
}
