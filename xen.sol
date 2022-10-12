/*
xen已经部署合约的地址
0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8 // Geoerli 
0x7bb191714f039ff944175489f07346710aff17b9 // Mainnet
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IXEN1{
    function claimRank(uint256 term) external;
    function claimMintReward() external;
    function approve(address spender, uint256 amount) external returns (bool);
}

interface IXEN2{
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract GET{
    IXEN1 private constant xen = IXEN1(0xe53d2d4A0CeC3e6200A6A68cac8b0575615283D0); // Geoerli
    // IXEN1 private constant xen = IXEN1(0xe53d2d4A0CeC3e6200A6A68cac8b0575615283D0); // Mainnet

    constructor() {
        xen.approve(msg.sender,~uint256(0));
    }
    
    function claimRank(uint256 term) public {
        xen.claimRank(term);
    }

    function claimMintReward() public {
        xen.claimMintReward();
        selfdestruct(payable(tx.origin));
    }
}

contract GETXEN {
    mapping (address=>mapping (uint256=>address[])) public userContracts;
    IXEN2 private constant xen = IXEN2(0xe53d2d4A0CeC3e6200A6A68cac8b0575615283D0); // Geoerli
    // IXEN2 private constant xen = IXEN2(0xe53d2d4A0CeC3e6200A6A68cac8b0575615283D0); // Mainnet

    function claimRank(uint256 times, uint256 term) external {
        address user = tx.origin;
        for(uint256 i; i<times; ++i){
            GET get = new GET();
            get.claimRank(term);
            userContracts[user][term].push(address(get));
        }
    }

    function claimMintReward(uint256 times, uint256 term) external {
        address user = tx.origin;
        for(uint256 i; i<times; ++i){
            uint256 count = userContracts[user][term].length;
            address get = userContracts[user][term][count - 1];
            GET(get).claimMintReward();
            address owner = tx.origin;
            uint256 balance = xen.balanceOf(get);
            xen.transferFrom(get, owner, balance);
            userContracts[user][term].pop();
        }
    }
}