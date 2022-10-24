// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract ChainLinkVRFDemo is VRFConsumerBaseV2{
    VRFCoordinatorV2Interface VRFInterface;
    uint64 subId;
    address owner;
    address vrfCoordinatorAddr=0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
    bytes32 keyHash=0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    //认为多少个交易以后交易就成功了，一般是12
    uint16 requestConfirmations=3;
    //gas limit上限
    uint32 callbackGasLimit=100000;
    //请求多少个随机数，上限是500
    uint32 numWords=3;
    //存储随机数
    uint256[] public s_randomWords;
    //第几次请求的数据
    uint256 public requestID;
    
    constructor(uint64 _subId) VRFConsumerBaseV2(vrfCoordinatorAddr){
        VRFInterface=VRFCoordinatorV2Interface(vrfCoordinatorAddr);
        subId=_subId;
        owner=msg.sender;
    }

    //接收方法
    function fulfillRandomWords(uint256 _requestID,uint256[] memory randomWords) internal override{
        s_randomWords=randomWords;
        requestID = _requestID;
    }
  
    function requestRandomWords() external{
        require(msg.sender==owner);
        requestID=VRFInterface.requestRandomWords(
            keyHash,
            subId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }
}