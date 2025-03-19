//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {deployFundMe} from "../../script/deployFundme.s.sol";

contract fundMeTest is Test {
    FundMe fundme;
    address user = makeAddr("user");
    uint256 constant GAS_PRICE = 1;
    uint256 constant BALANCE = 10 ether;

    modifier funded() {
        vm.prank(user);
        fundme.fund{value: 5 ether}();
        _;
    }

    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306)
        deployFundMe deploy = new deployFundMe();
        fundme = deploy.run();
        vm.deal(user, BALANCE);
    }

    function testMinUSD() public view {
        assertEq(fundme.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwner() public view {
        assertEq(fundme.getI_owner(), msg.sender);
    }

    function testVersion() public view {
        assertEq(fundme.getVersion(), 4);
    }

    function testRevert() public {
        vm.expectRevert(); // the next line should revert
        fundme.fund();
    }

    function testUpdateDataStructure() public {
        //next tx will be send by "user"
        uint256 initial = fundme.getAmountFunded(user);
        vm.prank(user);
        fundme.fund{value: 5e18}();
        uint256 latest = fundme.getAmountFunded(user);
        assert(initial < latest);
    }

    function testFunderToArray() public {
        vm.prank(user);
        address[] memory array = fundme.getS_funders();
        fundme.fund{value: 5e18}();
        address[] memory latest = fundme.getS_funders();
        assert(array.length < latest.length);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.expectRevert();
        vm.prank(user);
        fundme.withdraw();
    }

    function testWithdrawWithSinlgeFunder() public funded {
        //arrange
        uint256 startingBalance = fundme.getI_owner().balance;
        //Act
        vm.prank(fundme.getI_owner());
        fundme.withdraw();
        uint256 finalBalance = fundme.getI_owner().balance;
        //assert

        assert(startingBalance < finalBalance);
    }

    function testWithdrawFromMultipleUsers() public {
        uint160 nFunders = 10;
        uint160 startingFunder = 1;
        for (uint160 i = startingFunder; i <= nFunders; i++) {
            hoax(address(i), BALANCE);
            fundme.fund{value: 1 ether}();
        }
        uint256 startingOwnerBalance = fundme.getI_owner().balance;
        uint256 startingFundBalance = address(fundme).balance;

        vm.txGasPrice(GAS_PRICE);
        vm.startPrank(fundme.getI_owner());
        fundme.withdraw();
        vm.stopPrank();
        console.log(startingOwnerBalance);
        console.log(startingFundBalance);
        assert(address(fundme).balance == 0);
        assert(startingFundBalance + startingOwnerBalance == fundme.getI_owner().balance);
    }

    function testWithdrawFromMultipleUsersCheaper() public {
        uint160 nFunders = 10;
        uint160 startingFunder = 1;
        for (uint160 i = startingFunder; i <= nFunders; i++) {
            hoax(address(i), BALANCE);
            fundme.fund{value: 1 ether}();
        }
        uint256 startingOwnerBalance = fundme.getI_owner().balance;
        uint256 startingFundBalance = address(fundme).balance;

        vm.txGasPrice(GAS_PRICE);
        vm.startPrank(fundme.getI_owner());
        fundme.cheaperWithdraw();
        vm.stopPrank();
        console.log(startingOwnerBalance);
        console.log(startingFundBalance);
        assert(address(fundme).balance == 0);
        assert(startingFundBalance + startingOwnerBalance == fundme.getI_owner().balance);
    }
}
