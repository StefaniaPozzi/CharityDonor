// SPDX-License-Indentifier: MIT

pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";
import {FundMeDeploy} from "../../script/FundMeDeploy.s.sol";

contract FundMeTest is Test {
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

    modifier m_funded() {
        vm.prank(USER);
        fundMe.fund{value: AMOUNT_TO_BE_SENT}();
        _;
    }

    function test_MinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function test_OwnerIsSender() public {
        // simulated account inside Forge that calls Test
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function test_IsVersionAccurate() public {
        console.log(fundMe.getVersion());
        assertEq(fundMe.getVersion(), 4);
    }

    function test_getPrice() public {
        assertGt(PriceConverter.getPrice(fundMe.s_priceFeed()), 0);
    }

    function test_getConversionRate() public {
        assertGt(
            PriceConverter.getConversionRate(1e16, fundMe.s_priceFeed()),
            0
        );
    }

    function test_revertFundWhenThereAreNotenoughEthers() public {
        vm.expectRevert();
        fundMe.fund{value: 22e14}(); // 4$ >> 0.0022 ETH
    }

    function test_updateFundDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: AMOUNT_TO_BE_SENT}();
        uint256 amountSent = fundMe.getAddressToAmountFunded(USER);
        assertEq(AMOUNT_TO_BE_SENT, amountSent);
    }

    function test_updateAddressToAmount() public m_funded {
        address founder = fundMe.getFunder(0);
        assertEq(founder, USER);
    }

    function test_onlyOwnerCanwithdraw() public m_funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function test_successWithdrawSingleFounder() public m_funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }

    function test_successWithdrawMultipleFounders() public m_funded {
        uint160 numFounders = 3;
        uint160 startIndex = 1;
        for (uint160 i = startIndex; i < numFounders; i++) {
            vm.startPrank(address(i));
            vm.deal(address(i), AMOUNT_TO_BE_SENT);
            fundMe.fund{value: AMOUNT_TO_BE_SENT};
            vm.stopPrank();
            // hoax(address(i), AMOUNT_TO_BE_SENT);
            // fundMe.fund{value: AMOUNT_TO_BE_SENT};
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(
            fundMe.getOwner().balance ==
                startingFundMeBalance + startingOwnerBalance
        );
    }
}
