// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 0x9C47A6c4814CC8D70d459C02F4684F8A9D538A95 Goerli

contract XENToken is ERC20 {
    // constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}
    constructor() ERC20("XENToken", "XEN") {}

    function claimRank(uint256 term) public {
        address account = msg.sender;
        _mint(account, 1);
    }

    function claimMintReward() public {
        
    }
}
