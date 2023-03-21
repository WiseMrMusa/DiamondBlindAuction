// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;


interface ITestFacet {
    event AuctionStarted(address indexed nftOwner, address nftContractAddress, uint256 tokenID, uint256 period);
    event BidforNFT(address);
    event WithdrawBidNFT(address, uint256);
    event Winner();

    function AuctionNFT(address _nftContractAddress, uint256 _nftTokenID, uint256 _auctionPeriod) external;

    function placeBid(address _nftContractAddress, uint256 _nftTokenID) external payable;

    function withdrawBid(address _nftContractAddress, uint256 _nftTokenID) external;


    function endBid(address _nftContractAddress, uint256 _nftTokenID) external;

    function myBidForNFT(address _nftContractAddress, uint256 _nftTokenID) external view returns (uint256);
}