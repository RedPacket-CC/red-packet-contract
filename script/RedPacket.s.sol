// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {RedPacket} from "../src/RedPacket.sol";

contract RedPacketScript is Script {
    address public factory;



    function run() public {
        // Read the deployer's private key from environment variables

        factory=0xC84175A9943355Df5A14B08aD69282ec95FCB87d;

        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy the RedPacket contract
        RedPacket redpacket = new RedPacket(factory);
        // RedPacket redpacket = new RedPacket();
        console.log("RedPacket deployed to:", address(redpacket));

        // Encode the initializer function call
        // bytes memory data = abi.encodeCall(redpacket.initialize, (deployerAddress, factory));

        // Deploy the proxy contract with the implementation address and initializer data
        // ERC1967Proxy proxy = new ERC1967Proxy(address(redpacket), data);

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Log the proxy contract address
        // console.log("RedPacket UUPS Proxy Address:", address(proxy));
    }
}
