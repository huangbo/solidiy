// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// external 外部函数，本合约或者子合约调用需要通过this
// contract externalTest {
//     uint8 id;
//     function setId(uint8 newId) public {
//         id = newId;
//     }
//     function getId() public view returns (uint8) {
//         return this.getIdByexternal();
//     }

//     function getIdByexternal() external view returns(uint8) {
//         return id;
//     }
// }

// contract subExternalTest is externalTest {
//     function getexternalId() public view returns(uint8) {
//         return this.getIdByexternal();
//     }
// }

// internal 内部函数，不使用this
// contract internalTest {
//     uint8 internal id;
//     function setId(uint8 newId) public {
//         id = newId;
//     }
//     function getId() public view returns (uint8) {
//         return getIdByinternal();
//     }

//     function getIdByinternal() internal view returns(uint8) {
//         return id;
//     }
// }

// contract subinternalTest is internalTest {
//     function getsubId() public view returns(uint8) {
//         return id;
//     }

//     function getsubexternalId() public view returns(uint8) {
//         return getIdByinternal();
//     }
// }


// private 只能当前定义合约中访问，子合约无法访问
// contract privateTest {
//     uint8 private id;
//     function setId(uint8 newId) public {
//         id = newId;
//     }
//     function getId() public view returns (uint8) {
//         return getIdByprivate();
//     }

//     function getIdByprivate() private view returns(uint8) {
//         return id;
//     }
// }

// contract subprivateTest is privateTest {
//     function getsubId() public view returns(uint8) {
//         // return id;
//         // return getIdByprivate();
//         return getId();

//     }
// }

/*
 内部调用 不会产生EVM调用也称为消息调用，比如合约内部函数，父合约函数，库函数
 外部调用 会产生EVM调用，调用其他合约的函数，或者本合约的external函数

 public     在合约外部和合约内部都可以调用
 external   外部调用，只能在合约外部调用（如果在合约内部包括继承子合约调用，调用需要通过this，不推荐这样），需要this访问，因为只能在合约外部访问，所以子合约也不能override
            可以强制将函数存储的位置设置为calldata，这会节约函数执行时所需存储或计算资源
 internal   内部调用，当前合约和继承子合约可以调用
 private    只能当前合约中访问，继承子合约无法访问
*/

// contract FunctionTypes {
//     uint256 public number = 5;

//     function add(uint256 n) external pure returns(uint256) {
//         return n + 1;
//     }

//     function add1() external view returns(uint256) {
//         return number + 1;
//     }

//     function add2() external {
//         number = 10;
//     }
// }

/*
 pure 不能读也不能写链上的状态变量
 view 可以读到链上的状态变量，但是不能写(包括event)
 默认可以读写
*/

// contract PayTest {
//     function getbalance() public view returns(uint){
//         return address(this).balance;
//     }

//     function getaddr() public view returns(address){
//         return address(this);
//     }
//     function transferToContract() public payable returns(uint256) {
//         return address(this).balance;
//     }
//     // 给调用者转账
//     function transferFromContract() public payable {
//         payable(address(msg.sender)).transfer(10**18 wei);
//     }
// }

// contract Payable {
//     address payable public owner;
//     constructor() {
//         owner = payable(msg.sender);
//     }

//     function deposit() external payable {

//     }
//     function getBalance() external view returns(uint) {
//         return address(this).balance;
//     }
// }

/*
 payable 函数在被调用的时候会将value转入到合约
 全局变量 msg.sender msg.value msg表示调用这个函数的地址，可能是一个人也有可能是一个合约
*/

// contract Constants {
//     address public constant MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
//     uint public constant MY_UINT = 123;
// }

// contract ConstantsNew {
//     address public MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
//     uint public MY_UINT = 123;
// }

// contract Immutable {
//     // address public immutable owner = msg.sender;

//     address public immutable owner;
//     constructor(address x) {
//         owner = x;
//     }
// }

/*
constant   更节省gas，如果状态变量声明为 constant (常量)。在这种情况下，只能使用那些在编译时有确定值的表达式来给它们赋值。
immutable  比constant更节省gas，声明为不可变量(immutable)的变量的限制要比声明为常量(constant) 的变量的限制少：
            可以在合约的构造函数中或声明时为不可变的变量分配任意值。 不可变量在构造期间无法读取其值，并且只能赋值一次。
*/

// contract Error {
//     error MyError(address caller, uint i);

//     function testRequire(uint _i) public pure {
//         require(_i <= 10, "require: i > 10");
//     }
//     function testRevert(uint _r) public pure {
//         if (_r > 10) {
//             revert("revert: r > 10");
//         }
//     }
//     function testAssert(uint _a) public pure {
//         assert(_a == 123);
//     }
//     function testCustomError(uint _i) public view {
//         if (_i > 10) {
//             revert MyError(msg.sender, _i);
//         }
//     }
// }

/*
require revert assert 具有gas费的退还，状态的回滚
自定义错误有节省gas的作用
*/

// contract FunctionModifier {
//     bool public paused;
//     uint public count;

//     function setPaused(bool _paused) external {
//         paused = _paused;
//     }

//     modifier whenNotPaused() {
//         require(!paused, "paused");
//         _;
//     }

//     modifier cap(uint _x) {
//         require(_x > 10, "require error");
//         _;
//         count += 1;
//     }

//     function inc(uint _x) external whenNotPaused cap(_x) {
//         count += _x;
//     }
// }

/*
函数修改器
*/

// contract FunctionOutputs {
//     function returnMany() public pure returns(uint x, bool b) {
//         return (1, true);
//     }

//     function callRetrun() public pure returns(bool) {
//         // (uint x, bool b) = returnMany();
//         // return (x, b);
//         (, bool b) = returnMany();
//         return b;
//     }
// }

// contract Array {
//     uint[] public nums = [1, 2, 3]; // 可变长度数组
//     uint[3] public numsFixed = [4, 5, 6]; // 不可变长度数组

//     function examples() external {
//         nums.push(4);
//         delete nums[1]; // 不能删除元素，置为0，可以使用pop
//         nums.pop();
//         uint len = nums.length;

//         // create array in memory，在内存中只能定义定长数组，不能使用push pop方法
//         uint[] memory a = new uint[](5);
//     }

//     function getAllArray() external view returns(uint[] memory) {
//         return nums;
//     }

// }

// 数组

// contract memoryStorage {
//     uint public a = 1;

//     function modifierFun(uint memory x) external returns(uint) {
//         uint b = x;
//         return b;
//     }
// }

/*
 状态变量 – 变量值永久保存在合约存储空间中的变量。
 局部变量 – 变量值仅在函数执行过程中有效的变量，函数退出后，变量无效。
 全局变量 – 保存在全局命名空间，用于获取区块链相关信息的特殊变量。

 solidity数据存储位置有三类：storage，memory和calldata。
 memory：函数里的参数和临时变量一般用memory，存储在内存中，不上链。
 calldata：和memory类似，存储在内存中，不上链。与memory的不同点在于calldata变量不能修改 immutable。
 storage：合约中状态变都为storage，存储在以太坊区块链中

 storage给storage赋值或者memory给memory赋值，是创建引用，不同之间的两两赋值是创建副本。

Explicit data location for all variables of struct, array or mapping types is now mandatory. 
This is also applied to function parameters and return variables.
 For example, change uint[] x = m_x to uint[] storage x = m_x, and function f(uint[][] x) to function f(uint[][] memory x) where memory is the data location and might be replaced by storage or calldata accordingly.
  Note that external functions require parameters with a data location of calldata.
*/


// contract Mapping {
//     mapping(address => uint) public balances;
//     mapping(address => mapping(address => bool)) public isFriends;

//     function MappingFun() external {
//         balances[msg.sender] = 123;
//         uint val1 = balances[msg.sender];
//         uint val2 = balances[address(1)]; // 返回uint 的默认值0

//         isFriends[msg.sender][address(this)] = true;
//     }
// }

// contract TestContract1 {
//     address public owner = msg.sender;

//     function setOwner(address _owner) public {
//         require(msg.sender == owner, "not owner");
//         owner = _owner;
//     }
// }

// contract TestContract2 {
//     address public owner = msg.sender;
//     uint public value = msg.value;
//     uint public x;
//     uint public y;

//     constructor(uint _x, uint _y) payable {
//         x = _x;
//         y = _y;
//     }
// }

// contract Proxy {
//     event Deploy(address);

//     function deploy(bytes memory _code) external payable returns (address addr) {
//         assembly {
//             addr := create(callvalue(), add(_code, 0x20), mload(_code))
//         }
//         require(addr != address(0), "deploy failed");
//         emit Deploy(addr);
//     }

//     function execute(address _target, bytes memory _data) external payable {
//         (bool sucess, ) = _target.call{value: msg.value}(_data);
//         require(sucess, "failed");
//     }

    
// }

// contract Helper {
//     function getBytecode1() external pure returns (bytes memory) {
//         bytes memory bytecode = type(TestContract1).creationCode;
//         return bytecode;
//     }

//     function getBytecode2(uint _x, uint _y) external pure returns (bytes memory) {
//         bytes memory bytecode = type(TestContract2).creationCode;
//         return abi.encodePacked(bytecode, abi.encode(_x, _y)); // 构造函数
//     }

//     function getCalldata(address _owner) external pure returns (bytes memory) {
//         return abi.encodeWithSignature("setOwner(address)", _owner);
//     }
// }

// 代理合约

// contract Event {
//     event Log(string message, uint val);
//     event IndexedLog(address indexed sender, uint val); // indexed 可以链上检索

//     function example() external { //也是一个写入方法
//         emit Log("foo", 1234);
//         emit IndexedLog(msg.sender, 789);
//     }

//     event Message(address indexed _from, address indexed _to, string message);

//     function sendMessage(address _to, string calldata message) external {
//         emit Message(msg.sender, _to, message);
//     }

// }

// contract Account {
//     address public bank;
//     address public owner;

//     constructor(address _owner) payable {
//         owner = _owner;
//         bank = msg.sender;
//     }
// }

// contract AccountFactory {
//     uint public b;
//     Account[] public accounts;
//     function createAccount(address _owner) external payable {
//         Account account = new Account{value: 111}(_owner);
//         accounts.push(account);
//     }
//     function getBalance(address _owner) external {
//         b =  _owner.balance;
//     }
// }

// 工厂合约

// EVENT 体现在区块链浏览器或者交易记录中的logs中

// contract A {
//     function foo() public pure virtual returns (string memory) {
//         return 'A';
//     }
// }

// contract B is A {
//     function foo() public pure override virtual returns (string memory) {
//         return "B";
//     }
// }

// contract C is B {
//     function foo() public pure override virtual returns (string memory) {
//         return "C";
//     }
// }

// contract X is A, B { // 顺序从最接近基类的开始到最派生的顺序
//     function foo() public pure override(A, B) virtual returns (string memory) {
//         return "X";
//     }
// }
// virtual 可以被子合约重写，override 重写父合约

// ---------------

// contract S {
//     string public name;
//     constructor(string memory _name) {
//         name = _name;
//     }
// }

// contract T {
//     string public text;
//     constructor(string memory _text) {
//         text = _text;
//     }
// }

// contract Z is S, T {
//     constructor(string memory _name, string memory _text) S(_name) T(_text) {

//     }
// }
// 继承构造函数初始化

// contract E {
//     event Log(string message);

//     function foo() public virtual {
//         emit Log("E.foo");
//     }

//     function bar() public virtual {
//         emit Log("E.bar");
//     }
// }

// contract F is E {
//     function foo() public virtual override {
//         emit Log("F.foo");
//         E.foo();
//     }

//     function bar() public virtual override {
//         emit Log("F.bar");
//         super.bar();
//     }
// }

// contract G is E {
//     function foo() public virtual override {
//         emit Log("G.foo");
//         E.foo();
//     }

//     function bar() public virtual override {
//         emit Log("G.bar");
//         super.bar();
//     }
// }

// contract H is F, G {
//     function foo() public virtual override(F, G) {
//         emit Log("H.foo");
//         F.foo();
//     }

//     function bar() public virtual override(F, G) {
//         emit Log("H.bar");
//         super.bar();
//     }
// }

// 调用父级合约

// contract Fallback {
//     event Log(string func, address sender, uint value, bytes data);
//     fallback() external payable {
//         emit Log("fallback", msg.sender, msg.value, msg.data);
//     }
//     receive() external payable {
//         emit Log("receive", msg.sender, msg.value, "");
//     } 
// }

/*
 fallback回退函数当调用函数在合约不存在或者向合约中发放主币的时候（回退函数是payable的时候）
 msg.data存在的时候调用fallback，不存在调用receive，如果receive不存在，那么还是调用fallback
*/

// contract SendEther {
//     constructor() payable {}
//     // receive() external payable {}

//     function getBalance() external view returns (uint) {
//         return address(this).balance;
//     }
//     function sendViaTransfer(address payable _to) external payable {
//         // 发送主币的时候只携带2300个gas，如果gas消耗完或者发送主币的时候对方拒收或者逻辑异常，会revert
//         _to.transfer(123);
//     }
//     function sendViaSend(address payable _to) external payable {
//         // 发送主币的时候只携带2300个gas，会返回一个bool值，发送失败不会自动revert交易，几乎没有人用它
//        bool s = _to.send(123);
//        require(s, "send faild");
//     }

//     function sendViaCall(address payable _to) external payable {
//         // 会发送所有剩余的gas，返回一个bool和一个data，是最提倡的方法
//        (bool success, ) =  _to.call{value: 123}("");
//        require(success, "call faild");
//     }
// }

// contract EthReceiver {
//     event Log(uint amount , uint gas);

//     receive() external payable {
//         emit Log(msg.value, gasleft());
//     } 
// }
// 三种发送主币的方法

// contract TestContract {
//     uint public x;
//     uint public value = 123;

//     function setX(uint _x) external {
//         x = _x;
//     }
//     function getX() external view returns(uint) {
//         return x;
//     }
//     function setXandReceiveEther(uint _x) external payable {
//         x = _x;
//         value = msg.value;
//     }
//     function getXandValue() external view returns (uint, uint) {
//         return (x, value);
//     }
// }

// contract CallTestContract {
//     function setX(address _address, uint _x) external {
//         TestContract(_address).setX(_x);
//     }
//     function getX(address _address) external view returns (uint) {
//         return TestContract(_address).getX();
//     } 
//     function setXandReceiveEther(address _address, uint _x) external payable {
//         TestContract(_address).setX(_x);
//         TestContract(_address).setXandReceiveEther{value: msg.value}(_x);
//     }
//     function getXandValue(address _address) external view returns (uint _x, uint _value) {
//         (_x, _value) = TestContract(_address).getXandValue();
//     }
// }
// 一个合约调用另一个合约

// contract Counter {
//     uint public count;

//     function inc() external {
//         count += 1;
//     }

// }

// interface ICounter {
//     function count() external view returns (uint);
//     function inc() external;
// }

// contract CallInterface {
//     uint public count;
//     function callExample(address _address) external returns(uint) {
//         ICounter(_address).inc();
//         count = ICounter(_address).count();
//         return count;
//     }
// }
// 接口合约
// 所有函数都必须是external且不能有函数体, 继承接口的合约必须实现接口定义的所有功能

// contract interactBAYC {
//     // 利用BAYC地址创建接口合约变量（ETH主网）
//     IERC721 BAYC = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);

//     // 通过接口调用BAYC的balanceOf()查询持仓量
//     function balanceOfBAYC(address owner) external view returns (uint256 balance){
//         return BAYC.balanceOf(owner);
//     }

//     // 通过接口调用BAYC的safeTransferFrom()安全转账
//     function safeTransferFromBAYC(address from, address to, uint256 tokenId) external{
//         BAYC.safeTransferFrom(from, to, tokenId);
//     }
// }

/*
 无聊猿BAYC属于ERC721代币，实现了IERC721接口的功能。我们不需要知道它的源代码，只需知道它的合约地址，用IERC721接口就可以与它交互，
 比如用balanceOf()来查询某个地址的BAYC余额，用safeTransferFrom()来转账BAYC。
*/


// contract TestCall {
//     string public message;
//     uint public x;

//     event Log(string message);

//     fallback() external payable {
//         emit Log("fallback was called");
//     }

//     function foo(string memory _message, uint _x) external payable returns (bool, uint) {
//         message = _message;
//         x = _x;
//         return (true, 999);
//     }
// }

// contract Call {
//     bytes public data;
//     function callFoo(address _address) external payable {
//         (bool success, bytes memory _data) = _address.call{value: 111}(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));
//         require(success, "call faild");
//         data = _data;
//     }

//     function callDotExit(address _address) external {
//         (bool success, ) = _address.call(abi.encodeWithSignature("callDotExit()"));
//         require(success, "call faild");
//     }
// }

// 低级call使用


// contract TestDelegateCall {
//     uint public num;
//     address public sender;
//     uint public value;

//     function setVars(uint _num) external payable {
//         num = _num;
//         sender = msg.sender;
//         value = msg.value;
//     }
// }

// contract DelegateCall {
//     uint public num;
//     address public sender;
//     uint public value;

//     function setVars(address _address, uint _num) external payable {
//         // _address.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
//         (bool success, bytes memory _data) = _address.delegatecall(
//             abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
//         );
//         require(success, "fail call");
//     }
// }

// 委托调用，被委托调用合约的状态变量不会改变，只会使用被委托调用合约的逻辑。被调用合约相当于一个工具放到调用合约中



// contract TestMultiCall {
//     function func1() external view returns(uint, uint) {
//         return (1, block.timestamp);
//     }
//     function func2() external view returns(uint, uint) {
//         return (2, block.timestamp);
//     }

//     function getData1() external pure returns (bytes memory) {
//         return abi.encodeWithSelector(this.func1.selector);
//     }
//     function getData2() external pure returns (bytes memory) {
//         return abi.encodeWithSelector(this.func2.selector);
//     }
// }

// contract MultiCall {
//     function multiCall(address[] calldata targets, bytes[] calldata data) external view returns(bytes[] memory) {
//         require(targets.length == data.length, "target length != data length");
//         bytes[] memory results = new bytes[](data.length);
//         for (uint i = 0; i < targets.length; i++) {
//             (bool success, bytes memory result) = targets[i].staticcall(data[i]);
//             require(success, "call faild");
//             results[i] = result;
//         }
//         return results;
//     }
// }

/* 静态调用 call staticcall 
rpc节点限制每个客户端调用频率，合约的调用打包成一起一次性调用
call consumes less gas than calling the function on the contract instance. 
So in some cases call is preferred for gas optimisation.
Solidity has 2 more low level functions delegatecall and staticcall . staticcall is exactly the same as call with only difference that it cannot modify state of the contract being called. delegatecall is discussed below.
*/



// library ArrayLib {
//     function find(uint[] storage _arr, uint x) internal view returns(uint) {
//         for (uint i = 0; i < _arr.length; i++) {
//             if (_arr[i] == x) {
//                 return i;
//             }
//         }
//         return 10;

//     }
// }

// contract TestArray {
//     using ArrayLib for uint[];
//     uint[] public arr = [1, 3, 2];

//     function findTest() external view returns(uint) {
//         // return ArrayLib.find(2);
//         return arr.find(2); // 更推荐
//     }
// }
// 库合约的调用
// 如果有许多合约，它们有一些共同代码，则可以把共同代码部署成一个库。这将节省gas，因为gas也依赖于合约的规模。因此，可以把库想象成使用其合约的父合约。
// 使用父合约（而非库）切分共同代码不会节省gas，因为在Solidity中，继承通过复制代码工作。


// contract hashF {
//     function hash(string memory _text, string memory _otherText) external pure returns(bytes32) {
//         // return keccak256(abi.encode(_text, _otherText));
//         return keccak256(abi.encodePacked(_text, _otherText));
//     }
// }

/* hash算法 
1. 输入值相同输出值一定相同 2. 不可逆
abi.encodePacked 结果不补0 "AAA" "BBB" 和 "AA" "ABBB" 结果相同，可能会有不同的输入值相同的hasn值，可以在两个打包的字符串之间加上一个隔断符号
abi.encode 结果补0

*/ 


// contract VerfySig {
//     function verify(address _signer, string memory _message, bytes memory _sig)
//         external pure returns(bool) 
//     {
//         bytes32 messageHash = getMessageHash(_message);
//         bytes32 ethSignMessageHash = getEthSigndMessageHash(messageHash);
//         return recover(ethSignMessageHash, _sig) == _signer;
//     }

//     function getMessageHash(string memory _message) public pure returns(bytes32) {
//         return keccak256(abi.encodePacked(_message));
//     }
//     function getEthSigndMessageHash(bytes32 _message) public pure returns(bytes32) {
//         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _message));
//     }
//     function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) public pure returns(address) {
//         (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
//         return ecrecover(_ethSignedMessageHash, v, r, s);
//     }

//     function _split(bytes memory _sig) internal pure returns(bytes32 r, bytes32 s, uint8 v) {
//         require(_sig.length == 65, "invalid signature length");
//         assembly {
//             r := mload(add(_sig, 32))
//             s := mload(add(_sig, 64))
//             v := byte(0, mload(add(_sig, 96)))
//         }
//     }
// }
/*
Chrome Metamask 
ethereum.enable()
account = "0xc4cb0f670dfdc7c28f49f63feaacb2e10bafdec7"
hash = "0x9c97d796ed69b7e69790ae723f51163056db3d55a7a6a82065780460162d4812"
ethereum.request({method: "personal_sign", params: [account, hash]})
*/

// contract Kill {
//     constructor() payable {}
//     function kill() external {
//         selfdestruct(payable(msg.sender));
//     }
//     function test() external pure returns(uint) {
//         return 123;
//     }
// }

// 1 删除合约 2 强制发送主币到一个地址，为什么说强制，即使接受合约没有接受主币的回退函数都可以接受

// interface IERC721 {
//     function transferFrom(
//         address _from,
//         address _to,
//         uint _nftId
//     ) external;
// }

// contract DutchAuction {
//     uint private constant DURATION = 7 days;

//     IERC721 public immutable nft;
//     uint public immutable nftId;

//     address payable public immutable seller;
//     uint public immutable startingPrice;
//     uint public immutable startAt;
//     uint public immutable expiresAt;
//     uint public immutable discountRate;

//     constructor(
//         uint _startingPrice,
//         uint _discountRate,
//         address _nft,
//         uint _nftId
//     ) {
//         seller = payable(msg.sender);
//         startingPrice = _startingPrice;
//         startAt = block.timestamp;
//         expiresAt = block.timestamp + DURATION;
//         discountRate = _discountRate;

//         require(_startingPrice >= _discountRate * DURATION, "starting price < min");

//         nft = IERC721(_nft);
//         nftId = _nftId;
//     }

//     function getPrice() public view returns (uint) {
//         uint timeElapsed = block.timestamp - startAt;
//         uint discount = discountRate * timeElapsed;
//         return startingPrice - discount;
//     }

//     function buy() external payable {
//         require(block.timestamp < expiresAt, "auction expired");

//         uint price = getPrice();
//         require(msg.value >= price, "ETH < price");

//         nft.transferFrom(seller, msg.sender, nftId);
//         uint refund = msg.value - price;
//         if (refund > 0) {
//             payable(msg.sender).transfer(refund);
//         }
//         selfdestruct(seller);
//     }
// }

// 荷兰拍卖


/*
. 只能合约中所有的变量都可以直接获取到 any value in a smart contract storage can be accessed directly
  包括private变量，可以直接获取到web3.eth.getStorageAt("0x1f5d666f191c4d757854266ee661c47b0012f894", 0)

*/


// contract Bank {
//   uint256 public bank_funds;
//   address public owner;
//   address public deployer;

//   constructor(address _owner, uint256 _funds) {
//     bank_funds = _funds;
//     owner = _owner;
//     deployer = msg.sender;
//   }
// }

// contract BankFactory {
//   // instantiate Bank contract
//   Bank bank;
//   //keep track of created Bank addresses in array 
//   Bank[] public list_of_banks;

//   // function arguments are passed to the constructor of the new created contract 
//   function createBank(address _owner, uint256 _funds) external {
//     bank = new Bank(_owner, _funds);
//     list_of_banks.push(bank);
//   }
// }

// New