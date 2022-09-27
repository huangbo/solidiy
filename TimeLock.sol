// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;


contract TimeLock {
    error NotOwner();
    error AlreadyExist(bytes32);
    error NotAlreadyExist();
    error TimeNotArrived();

    address public owner;
    mapping(bytes32 => bool) public queued;
    uint constant MIN_TIMESTAMP = 100;
    constructor() {
        owner = msg.sender;
    }
    modifier OnlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    function getTxId(address _target, uint _value, string calldata _func, bytes calldata _data, uint _timestamp) 
        internal pure returns(bytes32)
    {
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }
    function queue(address _target, uint _value, string calldata _func, bytes calldata _data, uint _timestamp)
        external OnlyOwner
    {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        if (queued[txId]) {
            revert AlreadyExist(txId);
        }
        queued[txId] = true;

    }

    function execute(address _target, uint _value, string calldata _func, bytes calldata _data, uint _timestamp)
        external payable OnlyOwner returns(bytes memory)
    {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);

        if (!queued[txId]) {
            revert NotAlreadyExist();
        }
        if (block.timestamp > _timestamp + MIN_TIMESTAMP) {
            revert TimeNotArrived();
        }
        bytes memory data;
        if (bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);

        } else { // 如果是回退函数
            data = _data;
        }
        (bool ok, bytes memory res) = _target.call{value: _value}(data);
        require(ok, "faild call");
        return res;
    }
}

contract TestTimeLock {
    address public timelock;

    constructor(address _timelock) {
        timelock = _timelock;
    }
    function test() external view {
        require(msg.sender == timelock, "TestTimeLock not time lock");
    }
}