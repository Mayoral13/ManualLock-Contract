pragma solidity ^0.8.11;
contract TimeLockWallet{
    address payable to;
    address private owner;
    uint BalanceRecieved;
    bool lock;
    uint amount;
    enum State {Locked,Open}
    State public state;
    event changeOwner(address indexed _from,address indexed _to);
    event recieve(address indexed _from,uint _value);
    event locked(address indexed _from);
    event unlock(address indexed _from);
    event withdraw(address indexed _from,address indexed _to,uint _value);

    constructor(){
        owner = msg.sender;
    }
    function ChangeOwner(address _to)external returns(bool success){
         require(msg.sender == owner,"You are not the Owner");
         owner = _to;
         emit changeOwner(msg.sender, _to);
         return true;

    }
    
   
    function Recieve()external payable returns(bool success){
        state = State.Open;
        lock = false;
        BalanceRecieved += msg.value;
        emit recieve(msg.sender, msg.value);
        return true;
    }

    function Lock(bool _lock)external{
        require(msg.sender == owner,"You are not the Owner");
        state = State.Locked;
        lock = _lock;
        lock = true;
        emit locked(msg.sender);
        
    }

    function Withdraw(address payable _to , uint _amount)external payable{
        require(msg.sender == owner,"You are not the Owner");
        to = _to;
        amount = _amount;
        require(!lock == true,"Withdrawals are Locked");
        _to.transfer(amount);
        emit withdraw(msg.sender, _to, msg.value);
    }

    function Balance() external view returns (uint){
        return address(this).balance;
    }

    function Unlock(bool __lock)external{
        require(msg.sender == owner,"You are not the Owner");
       lock =__lock;
       lock = false;
       state = State.Open;
       emit unlock(msg.sender);
    }
    function ReturnOwner()external view returns(address){
        return owner;
    }


    
}