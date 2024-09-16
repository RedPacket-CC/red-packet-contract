// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {RedPacketFactory} from "../src/RedPacketFactory.sol";
import {RedPacketNFT} from "../src/RedPacketNFT.sol";
import {ERC6551Registry} from "../src/ERC6551Registry.sol";

contract RedPacketFactoryScript is Script {
    RedPacketFactory public factory;


    function run() public {
        
        address registry = 0x724401E256D94eA9c8567cCbE23eC977B20AE37b;
        address implementation = 0x8f67ff5233dD6733a9338197C53CA076098400Ba;

        vm.startBroadcast();

        factory = new RedPacketFactory (registry, implementation);

        console.log("RedPacketFactory deployed to:", address(factory));

        vm.stopBroadcast();
    }
}
