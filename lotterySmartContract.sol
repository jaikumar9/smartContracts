//SPDX-License-Identifier: Unlicense

// contract address = 0xa152964a680a5b1d14194749fe72dc90c6301789 on Sepolia testnet

pragma solidity ^0.8.0;

contract Lottery {

        address public manager;
        address payable[] public participents;
    

        constructor()
        {
         manager=msg.sender;   // globel variable
        }
       modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }
    function setOwner(address newOwner) public onlyManager {
        manager = newOwner;
    }
     
     receive() external payable {
         require(msg.sender!=manager, "manager did't allow to participate");
         require(msg.value == 1 ether,"you Dont have sufficient funds");

         participents.push(payable(msg.sender));
     
     }
    function getBalance() public view returns(uint balance) {
        require (msg.sender == manager,"only manager call this function");
        return address(this).balance;
    }       

     function getParticipantCount() external view returns (uint) {
        return participents.length;
    } 

        function pickWinner()  public   {
        require(msg.sender == manager, "Only the owner can pick a winner");
        require(participents.length > 3, "No participants in the lottery");

        uint256 winnerIndex = random() % participents.length;
        address winner = participents[winnerIndex];
        // delete participents; // Reset participants array
        participents  = new address payable[](0); // Reset participants array

        // Transfer the lottery balance to the winner
        uint256 balance = address(this).balance;
        payable (winner).transfer(balance);
        // return winner;

    }

    function random() private view returns (uint256) {  // view = didnt change in state variable.
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participents.length)));
    }


}
