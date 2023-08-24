// SPDX-License-Indentifier: MIT

pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";
import {FundMeDeploy} from "../../script/FundMeDeploy.s.sol";
import {FundInteraction} from "../../script/Interactions.sol";

contract FundMeTestIntegration is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant AMOUNT_TO_BE_SENT = 10e18;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint8 constant GAS_PRICE = 1;

    //FundMeTest address(this) is FundMedeploy msg.sender
    //Arrange, Act, Assert the test
    function setUp() external {
        FundMeDeploy deploy = new FundMeDeploy();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteraction() public {
        FundInteraction fundInteractionContract = new FundInteraction();
        vm.prank(USER);
        vm.deal(USER, STARTING_BALANCE);
        fundInteractionContract.fundFundMe(address(fundMe));

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }
}
