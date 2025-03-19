//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {helperConfig} from "../script/helperConfig.s.sol";

contract deployFundMe is Script {
    function run() external returns (FundMe) {
        helperConfig config = new helperConfig();
        address ethUsd = config.active();
        vm.startBroadcast();
        FundMe fundme = new FundMe(ethUsd);
        vm.stopBroadcast();
        return fundme;
    }
}
