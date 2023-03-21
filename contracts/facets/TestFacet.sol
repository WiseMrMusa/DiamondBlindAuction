// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { LibTestFacet } from "../libraries/LibTestFacet.sol";

contract TestFacet {
    event AuctionStarted(address indexed nftOwner, address nftContractAddress, uint256 tokenID, uint256 period);
    event BidforNFT(address);
    event WithdrawBidNFT(address, uint256);
    event Winner();
    function AuctionNFT(address _nftContractAddress, uint256 _nftTokenID, uint256 _auctionPeriod) external {
        LibTestFacet.AuctionNFT(_nftContractAddress, _nftTokenID, _auctionPeriod);
    }

    function placeBid(address _nftContractAddress, uint256 _nftTokenID) external payable {
        LibTestFacet.placeBid(_nftContractAddress, _nftTokenID, msg.value);
    }
    function withdrawBid(address _nftContractAddress, uint256 _nftTokenID) external {
        LibTestFacet.withdrawBid( _nftContractAddress, _nftTokenID);
    }


    function endBid(address _nftContractAddress, uint256 _nftTokenID) external {
        LibTestFacet.endBid(_nftContractAddress, _nftTokenID);
    }

    function myBidForNFT(address _nftContractAddress, uint256 _nftTokenID) external view returns (uint256) {
        return LibTestFacet.myBidForNFT(_nftContractAddress, _nftTokenID);
    }
}