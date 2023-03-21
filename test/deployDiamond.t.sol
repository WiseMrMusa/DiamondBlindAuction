// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "./NFTContract.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../../lib/forge-std/src/Test.sol";
import "../contracts/Diamond.sol";
import "../contracts/facets/TestFacet.sol";
import "../contracts/interfaces/ITestFacet.sol";

contract DiamondDeployer is Test, IDiamondCut {
    //contract types of facets to be deployed
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;
    TestFacet thisFac;
    NFTContract public myNFT; 

    function testDeployDiamond() public {
        //deploy facets
        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(address(this), address(dCutFacet));
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();

        //upgrade diamond with facets

        //build cut struct
        FacetCut[] memory cut = new FacetCut[](2);

        cut[0] = (
            FacetCut({
                facetAddress: address(dLoupe),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cut[1] = (
            FacetCut({
                facetAddress: address(ownerF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );

        //upgrade diamond
        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");

        //call a function
        DiamondLoupeFacet(address(diamond)).facetAddresses();
    }

    function testDeployTestFacet() public {
        testDeployDiamond();
        thisFac = new TestFacet();

        //upgrade diamond with facets

        //build cut struct
        FacetCut[] memory cut = new FacetCut[](1);

        cut[0] = (
            FacetCut({
                facetAddress: address(thisFac),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("TestFacet")
            })
        );

        //upgrade diamond
        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");
    }

    function testAuctionNFT() public {
        testDeployTestFacet();
        vm.startPrank(address(0x10));
        myNFT = new NFTContract("","");
        myNFT.safeMint(address(0x10),1);
        myNFT.approve(address(diamond),1);
        vm.stopPrank();
        AuctionNFT();
    }

    function testPlaceBid() public {
        testAuctionNFT();
        placeBid(address(0x01), 0.08 ether);
        placeBid(address(0x02), 0.09 ether);
        placeBid(address(0x03), 0.10 ether);
        placeBid(address(0x04), 29.9 ether);
    }

    function testEndBid() public {
        testPlaceBid();
        // blindNFTAuction.getHighestBidder(address(myNFT),1);
        vm.prank(address(0x10));
        ITestFacet(address(diamond)).endBid(address(myNFT),1);
    }

    function testMyBid() public {
        testAuctionNFT();
        placeBid(address(0x01), 0.08 ether);
        ITestFacet(address(diamond)).myBidForNFT(address(myNFT),1);
        placeBid(address(0x02), 0.09 ether);
        ITestFacet(address(diamond)).myBidForNFT(address(myNFT),1);
        placeBid(address(0x03), 0.10 ether);
        ITestFacet(address(diamond)).myBidForNFT(address(myNFT),1);
        placeBid(address(0x04), 29.9 ether);
        ITestFacet(address(diamond)).myBidForNFT(address(myNFT),1);
        // blindNFTAuction.getHighestBidder(address(myNFT),1);
    }

    function testWithDrawBid() public {
        testEndBid();
        vm.prank(address(0x02));
        ITestFacet(address(diamond)).withdrawBid(address(myNFT),1);
        vm.prank(address(0x03));
        ITestFacet(address(diamond)).withdrawBid(address(myNFT),1);
    }

    function testFailWithDrawBid() public {
        testEndBid();
        vm.prank(address(0x02));
        ITestFacet(address(diamond)).withdrawBid(address(myNFT),1);
        vm.prank(address(0x02));
        ITestFacet(address(diamond)).withdrawBid(address(myNFT),1);
    }













    function AuctionNFT() public {
        vm.prank(address(0x10));
        ITestFacet(address(diamond)).AuctionNFT(address(myNFT),1,44950490459045);
    }

        function placeBid(address addr, uint256 bid) public {
        vm.deal(addr,100 ether);
        vm.prank(addr);
        ITestFacet(address(diamond)).placeBid{value: bid}(address(myNFT),1);
    }

    function generateSelectors(string memory _facetName)
        internal
        returns (bytes4[] memory selectors)
    {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}
}