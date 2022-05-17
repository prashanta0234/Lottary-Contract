// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0<0.9.0;

contract Lottary{
    address public manager;
    address payable[] public participants;
    address public  setwinner;

    constructor(){
        manager=msg.sender;
    }
    receive() external payable{
        require(msg.value==2 ether,"You have to pay 2 Ether");
        participants.push(payable(msg.sender));
    }
    function checkBalance() public view returns(uint){
        require(msg.sender==manager,"Sorry You are not Manager");
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
    function selectWiner() public{
        require(participants.length>=3);
        require(msg.sender==manager,"You are not the manager");
        uint r=random();
        address payable winner;
        uint index= r% participants.length;
        winner=participants[index];
        // winner.transfer(checkBalance());
        setwinner=winner;
        (bool success,)=winner.call{value:checkBalance()}("");
        require(success,"sorry money isnot send successfull");
        participants=new address payable[](0);


    }
}
