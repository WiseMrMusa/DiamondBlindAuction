// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

    struct NFTAuction {
        address payable nftOwner;

        uint256 auctionStartTime;
        uint256 auctionEndTime;

        address[] bidders;
    }

    struct Bid {
        address payable bidder;
        uint256 bid;
    }

struct AppStorage {

    /// @notice This holds each NFT's details
    mapping (address => mapping(uint256 => NFTAuction)) nftAuctionDetails;
    mapping (address => mapping(uint256 => mapping(address => Bid))) bidInformation;
    mapping (address => mapping(uint256 => address[])) nftBidders;
    
    /// @notice This holds the contract addresses NFTs are auctioned
    address[] nftContractAddress;

    /// @notice This holds the list of tokenIDs in each stored NFT Collection
    mapping (address => uint256[]) tokenIDperAddress;
}

library LibAppStorage {
    function myDiamondStorage() internal pure returns (AppStorage storage ds){
        assembly {
            ds.slot := 0
        }
    }
}