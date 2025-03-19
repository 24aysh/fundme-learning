// //Fund script, withdraw script

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
// import {Script, console} from "forge-std/Script.sol";
// import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
// import {FundMe} from "../src/fundme.sol";

// contract Fundfundme is Script {
//     uint256 constant SEND_VALUE = 1 ether;

//     function run() external {
//         address recentDeployed = DevOpsTools.get_most_recent_deployment(
//             "FundMe",
//             block.chainid
//         );
//         fundRecentDeployed(recentDeployed);
//     }

//     function fundRecentDeployed(address recentDeployed) public {
//         vm.startBroadcast();
//         FundMe(payable(recentDeployed)).fund{value: SEND_VALUE}();
//         vm.stopBroadcast();
//     }
// }

// contract Withdrawfundme is Script {}
