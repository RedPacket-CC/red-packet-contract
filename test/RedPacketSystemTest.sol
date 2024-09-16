// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/RedPacket.sol";
import "forge-std/Test.sol";
import "../src/RedPacketFactory.sol";
import "../src/RedPacketNFT.sol";
import "../src/ERC6551Registry.sol";
import "../src/ERC6551Account.sol";
import "../src/interface/IERC6551Account.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract RedPacketTest is Test {
    RedPacket public redPacket;
    RedPacketFactory public factory;
    RedPacketNFT public nft;
    ERC6551Registry public registry;
    ERC6551Account public implementation;
    ERC1967Proxy proxy;
    address public owner;
    address public recipient;

    event ERC6551AccountCreated(
        address account,
        address indexed implementation,
        bytes32 salt,
        uint256 chainId,
        address indexed tokenContract,
        uint256 indexed tokenId
    );

    event TokenReceived(address indexed operator, address indexed from, uint256 indexed tokenId, bytes data);

    function setUp() public {
        owner = address(this);
        recipient = address(0x123);

        // Deploy contracts
        nft = new RedPacketNFT();

        registry = new ERC6551Registry();
        implementation = new ERC6551Account();

        factory = new RedPacketFactory(address(registry), address(implementation));

        redPacket = new RedPacket(address(factory));
        factory.setCoverToNft(0,address(nft));

        // Deploy mock ERC20 token
       
    }


    function testCreateRedPacket() public returns (address) {

      
        

        uint256 cover = 0;


        // Create red packet
        address wallet = redPacket.createRedPacketWithEth{value: 1 ether}(recipient, cover);

        console.log("balance",address(wallet).balance);

        console.log("wallet",recipient);
        console.log("wallet",wallet);
        console.log("nft",nft.balanceOf(recipient));

        return wallet;


    }
    

    function testOpenRedPacket() public {
        address wallet = testCreateRedPacket();

        console.log("walletbalance",address(wallet).balance);
        console.log("recepientbalcne",recipient.balance);
        
        IERC6551Account accountInstance = IERC6551Account(payable(wallet));

        vm.deal(address(recipient),1 ether) ;

    
        // bytes memory data = abi.encodeWithSelector(IERC20.transfer.selector, recipient, =);
        // (address decodeRecipient, uint256 decodeERC20Balance) = decodeData(data);
        // assertEq(decodeRecipient, recipient);
    

        // // Call the execute function on the ERC6551Account to transfer ERC20 tokens
        vm.prank(recipient);
        accountInstance.execute(recipient, 1 ether , "", 0);
        console.log("recepientbalcne",recipient.balance);
        // assertEq(accountInstance.state(), 1);
        // uint256 recipientErc20Balance = IERC20(mockERC20).balanceOf(recipient);
        // assertEq(recipientErc20Balance, 1000 * 10 ** 18);
        // uint256 openAfterERC20Balance = IERC20(mockERC20).balanceOf(account);
        // assertEq(openAfterERC20Balance, 0 * 10 ** 18);
    }

   

    

    function decodeData(bytes memory data) public pure returns (address reci, uint256 erc20Balance) {
        // 检查 data 的长度是否足够
        require(data.length >= 56, "Data is too short"); // 4 bytes for selector + 20 bytes for address + 32 bytes for uint256

        // 创建一个新的 bytes 数组来存储解码的数据
        bytes memory encodedData = new bytes(data.length - 4);

        // 将 data 的内容复制到新的数组中，跳过前 4 个字节
        for (uint256 i = 4; i < data.length; i++) {
            encodedData[i - 4] = data[i];
        }

        // 解码参数
        (reci, erc20Balance) = abi.decode(encodedData, (address, uint256));
    }
}

// Mock ERC20 token for testing
