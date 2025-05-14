// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/MyNFTCollection.sol";

contract MyNFTCollectionTest is Test {
    MyNFTCollection public nftCollection;
    address payable public owner = payable(address(this));
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");
    
    uint256 public constant MAX_SUPPLY = 100;
    uint256 public constant MINT_PRICE = 0.001 ether;
    uint256 public constant TEST_FUNDS = 1 ether;

    receive() external payable {}
    fallback() external payable {}

    function setUp() public {
        require(TEST_FUNDS >= MAX_SUPPLY * MINT_PRICE, "Not enough test funds for testing");
        nftCollection = new MyNFTCollection(owner);
        require(MINT_PRICE == nftCollection.MINT_PRICE(), "Mint price mismatch");
        require(MAX_SUPPLY == nftCollection.MAX_SUPPLY(), "Max supply mismatch");
    }

    function test_SuccessfulMint() public {
        vm.deal(user1, TEST_FUNDS);
        uint256 mintAmount = 3;
        
        vm.prank(user1);
        nftCollection.mint{value: MINT_PRICE * mintAmount}(mintAmount, user1);
        
        assertEq(nftCollection.balanceOf(user1), mintAmount, "User NFT balance mismatch");
        assertEq(nftCollection.totalSupply(), mintAmount, "Total supply mismatch");
        assertEq(address(nftCollection).balance, MINT_PRICE * mintAmount, "Contract balance mismatch");
    }

    function test_MintLimitPerTx() public {
        vm.deal(user1, TEST_FUNDS);
        vm.prank(user1);
        
        vm.expectRevert(abi.encodeWithSignature("InvalidAmount()"));
        nftCollection.mint{value: MINT_PRICE * 4}(4, user1);
    }

    function test_ExceedsWalletLimit() public {
        vm.deal(user1, TEST_FUNDS);
        vm.startPrank(user1);
        nftCollection.mint{value: MINT_PRICE * 3}(3, user1);
        nftCollection.mint{value: MINT_PRICE * 3}(3, user1);

        vm.expectRevert(abi.encodeWithSignature("ExceedsWalletLimit()"));
        nftCollection.mint{value: MINT_PRICE}(1, user1);
        vm.stopPrank();
    }

    function test_MintUnderpayment() public {
        vm.deal(user1, TEST_FUNDS);
        vm.prank(user1);
        vm.expectRevert(abi.encodeWithSignature("IncorrectETHValue()"));
        nftCollection.mint{value: MINT_PRICE - 1}(1, user1);
    }

    function test_MintToDifferentRecipient() public {
        vm.deal(user1, TEST_FUNDS);
        vm.prank(user1);
        nftCollection.mint{value: MINT_PRICE * 2}(2, user2);
        
        assertEq(nftCollection.balanceOf(user2), 2, "Recipient should have NFTs");
        assertEq(nftCollection.balanceOf(user1), 0, "Sender should not receive NFTs");
    }

    function test_MintZeroAmount() public {
        vm.deal(user1, TEST_FUNDS);
        vm.prank(user1);
        vm.expectRevert(abi.encodeWithSignature("InvalidAmount()"));
        nftCollection.mint{value: 0}(0, user1);
    }

    function test_BalanceOfAfterMultipleMints() public {
        vm.deal(user1, TEST_FUNDS);
        vm.prank(user1);
        nftCollection.mint{value: MINT_PRICE * 2}(2, user1);

        vm.prank(user1);
        nftCollection.mint{value: MINT_PRICE * 1}(1, user1);
        
        assertEq(nftCollection.balanceOf(user1), 3, "Accumulated balance mismatch");
    }

    function test_WithdrawAsNotOwner() public {
        uint256 contractBalance = 0.5 ether;
        
        vm.deal(address(nftCollection), contractBalance);
        
        vm.prank(user1);
        vm.expectRevert();
        nftCollection.withdraw(contractBalance, payable(owner));
    }

    function test_WithdrawAsOwner() public {
        uint256 initialBalance = owner.balance;
        uint256 contractBalance = 0.5 ether;
        
        vm.deal(address(nftCollection), contractBalance);
        assertEq(address(nftCollection).balance, contractBalance, "Contract should have correct balance");
        
        vm.prank(owner);
        nftCollection.withdraw(contractBalance, payable(owner));

        assertEq(owner.balance, initialBalance + contractBalance, "Owner should receive funds");
        assertEq(address(nftCollection).balance, 0, "Contract balance should be zero");
    }

    function test_WithdrawZeroAmount() public {
        vm.deal(address(nftCollection), 1 ether);
        vm.prank(owner);
        vm.expectRevert(abi.encodeWithSignature("InvalidAmount()"));
        nftCollection.withdraw(0, payable(owner));
    }

    function test_WithdrawToZeroAddress() public {
        vm.deal(address(nftCollection), 1 ether);
        vm.prank(owner);
        vm.expectRevert(abi.encodeWithSignature("ZeroAddress()"));
        nftCollection.withdraw(0.1 ether, payable(address(0)));
    }
}
