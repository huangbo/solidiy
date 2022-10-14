// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

function xen() pure returns(IXEN) {
    return IXEN(0x9C47A6c4814CC8D70d459C02F4684F8A9D538A95);
}

interface IXEN{
    function claimRank(uint256 term) external;
    function claimMintReward() external;
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);

}

contract GET{
    address owner;
    function claimRank(uint256 term) public {
        xen().claimRank(term);
        owner = tx.origin;
    }

    function claimMintReward() public {
        require(msg.sender == owner);
        xen().claimMintReward();
        uint256 balance = xen().balanceOf(address(this));
        xen().transfer(owner, balance);
        selfdestruct(payable(tx.origin));
    }
}
// 0xcb1bf0801fa7c4a7991f6c820e895285c782351c Goerli 
contract GETXEN {
    mapping (address=>mapping (uint256=>address[])) public userContracts;
    address private immutable get;

    constructor() {
        get = address(new GET());
    }

    function _clone(address target) internal returns (address result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            result := create(0, clone, 0x37)
        }
    }

    function claimRank(uint256 times, uint256 term) external {
        address user = tx.origin;
        for(uint256 i; i<times; ++i){
            address clone = _clone(get);
            GET(clone).claimRank(term);
            userContracts[user][term].push(address(clone));
        }
    }

    function claimMintReward(uint256 times, uint256 term) external {
        address user = tx.origin;
        for(uint256 i; i<times; ++i){
            uint256 count = userContracts[user][term].length;
            address clone = userContracts[user][term][count - 1];
            GET(clone).claimMintReward();
            userContracts[user][term].pop();
        }
    }
}