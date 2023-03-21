// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { LibAppStorage, AppStorage, NFTAuction , Bid} from "./LibAppStorage.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

library LibTestFacet {
    event AuctionStarted(address indexed nftOwner, address nftContractAddress, uint256 tokenID, uint256 period);
    event BidforNFT(address);
    event WithdrawBidNFT(address, uint256);
    event Winner();
    function AuctionNFT(address _nftContractAddress, uint256 _nftTokenID, uint256 _auctionPeriod) internal {
            AppStorage storage s = LibAppStorage.myDiamondStorage();
            s.nftContractAddress.push(_nftContractAddress);
            s.tokenIDperAddress[_nftContractAddress].push(_nftTokenID);
            NFTAuction storage myNftAuction = s.nftAuctionDetails[_nftContractAddress][_nftTokenID];
            myNftAuction.nftOwner = payable(msg.sender);
            myNftAuction.auctionStartTime = block.timestamp;
            myNftAuction.auctionEndTime = block.timestamp + _auctionPeriod;
            IERC721(_nftContractAddress).transferFrom(msg.sender,address(this),_nftTokenID);
            emit AuctionStarted(msg.sender, _nftContractAddress, _nftTokenID, _auctionPeriod);
    }

    function placeBid(address _nftContractAddress, uint256 _nftTokenID, uint256 msgValue) internal {
        AppStorage storage s = LibAppStorage.myDiamondStorage();
        NFTAuction storage bidNFT = s.nftAuctionDetails[_nftContractAddress][_nftTokenID];
        require(bidNFT.nftOwner != address(0), "This NFT is not for auction");
        require(bidNFT.auctionEndTime > block.timestamp, "The auction has ended");
        bidNFT.bidders.push(payable(msg.sender));
        Bid storage myBid = s.bidInformation[_nftContractAddress][_nftTokenID][msg.sender];
        s.nftBidders[_nftContractAddress][_nftTokenID].push(msg.sender);
        myBid.bidder = payable(msg.sender);
        myBid.bid += msgValue;
        emit BidforNFT(msg.sender);
    }
    function withdrawBid(address _nftContractAddress, uint256 _nftTokenID) internal {
        AppStorage storage s = LibAppStorage.myDiamondStorage();
        NFTAuction storage bidNFT = s.nftAuctionDetails[_nftContractAddress][_nftTokenID];
        require(bidNFT.nftOwner != address(0), "This NFT is not for auction");
        // bidNFT.bidders.push(payable(msg.sender));
        Bid storage myBid = s.bidInformation[_nftContractAddress][_nftTokenID][msg.sender];
        uint256 tBid = myBid.bid;
        require(myBid.bidder == msg.sender, "Only bidder can withdraw!");
        require(tBid > 0, "You don't have money here");
        myBid.bid = 0;
        payable(msg.sender).transfer(tBid);
        emit WithdrawBidNFT(msg.sender, tBid);
    }

    function getHighestBidder(address _nftContractAddress, uint256 _nftTokenID) internal view returns (Bid memory) {
        AppStorage storage s = LibAppStorage.myDiamondStorage();
        Bid memory agbaBidder;
        uint256 nftBiddersLength = s.nftBidders[_nftContractAddress][_nftTokenID].length;
        address[] memory nftBiddders = s.nftBidders[_nftContractAddress][_nftTokenID];
        for (uint256 i; i < nftBiddersLength; i++){
            Bid memory Bidder =  s.bidInformation[_nftContractAddress][_nftTokenID][nftBiddders[i]];
                if(Bidder.bid > agbaBidder.bid){
                    agbaBidder = Bidder;
                }
        }
        return agbaBidder;
    }

    function endBid(address _nftContractAddress, uint256 _nftTokenID) internal {
        AppStorage storage s = LibAppStorage.myDiamondStorage();
        require(msg.sender == s.nftAuctionDetails[_nftContractAddress][_nftTokenID].nftOwner, "Only owner can end bid");
        Bid memory winner = getHighestBidder(_nftContractAddress,_nftTokenID);
        Bid storage myBid = s.bidInformation[_nftContractAddress][_nftTokenID][winner.bidder];
        myBid.bid = 0;
        IERC721(_nftContractAddress).transferFrom(address(this),winner.bidder,_nftTokenID);
        address payable nftOwner = s.nftAuctionDetails[_nftContractAddress][_nftTokenID].nftOwner;
        uint256 bid = s.bidInformation[_nftContractAddress][_nftTokenID][msg.sender].bid;
        (nftOwner).transfer(bid);
        emit Winner();
    }

    function myBidForNFT(address _nftContractAddress, uint256 _nftTokenID) internal view returns (uint256) {
        AppStorage storage s = LibAppStorage.myDiamondStorage();
        return s.bidInformation[_nftContractAddress][_nftTokenID][msg.sender].bid;
    }
}