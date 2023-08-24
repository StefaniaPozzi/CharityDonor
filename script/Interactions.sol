//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundInteraction is Script {
    uint256 constant FOUNDING_CONTRACT_AMOUNT = 0.01 ether;

    function fundFundMe(address contractDeployment) public {
        FundMe(payable(contractDeployment)).fund{
            value: FOUNDING_CONTRACT_AMOUNT
        }();
    }

    function run() external {
        /* It looks up in the broadcast folder (chainid) and get the most recent deployment.abi
        >> ! NOTE We do not pass the address of the deployed contract every single time 
        ffi=true in the foundry.toml*/
        address mostRecentlyDeployedFundMe = DevOpsTools
            .get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast(); //collects tx for onchain broadcasting
        fundFundMe(mostRecentlyDeployedFundMe);
        vm.stopBroadcast();
    }
}

contract WithdrawInteraction is Script {
    function run() external {}
}
