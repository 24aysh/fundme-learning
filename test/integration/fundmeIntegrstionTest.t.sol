//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {deployFundMe} from "../../script/deployFundme.s.sol";

contract IntegrationTest is Test {
    FundMe fundme;
    address user = makeAddr("user");
    uint256 constant GAS_PRICE = 1;
    uint256 constant BALANCE = 10 ether;

    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306)
        deployFundMe deploy = new deployFundMe();
        fundme = deploy.run();
        vm.deal(user, BALANCE);
    }
}
