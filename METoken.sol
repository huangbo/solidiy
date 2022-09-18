// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IIERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract METoken is ERC20 {
    // constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}
    constructor() ERC20("METoken", "MIMI") {}

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }
}


contract MEContract {
    IIERC20 public Token;
    function trans(address _token, address _to) external  {
        Token = IIERC20(_token);
        Token.transfer(_to, 1);
    }
}
