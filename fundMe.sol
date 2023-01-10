// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

// a contract for accepting payments
contract FundMe {
        using PriceConverter for uint256;
    // an array of addresses that interacts with the contract
    address[] public funders;
    
    // mapping addresses to funds sent from them
    mapping(address => uint256) public addressToAmount;

    uint256 public minimumUsd = 50;

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    // payable = contract can accept eth
    // require makes sure every part of the function executes otherwise it reverts.
    // msg.value is in wei by default and contracts primarily deal with wei. 1eth = 1 *10**8 wei
    function fund() public payable {
        require(
           msg.value.getConversionRate() >= minimumUsd,
            "Did not send enough funds!"
        );
        //adds the sender's address to the funders array
        funders.push(msg.sender);
        // sets the amount sent to the address that sent it
        addressToAmount[msg.sender] += msg.value;
    }


    function withdraw() public onlyOwner{
        // resets the Amount funded by all address to 0
        for(
            uint256 funderIndex = 0; funderIndex < funders.length; funderIndex = funderIndex++){
                address funder = funders[funderIndex];
                addressToAmount[funder] = 0; 
            }

            // resets the array to an empty one
        funders = new address[](0);

    // send the balance of this contract to the call address
        payable(msg.sender).transfer(address(this).balance);
    }
   
// creates a modifier that can be attached to any function so it runs the modifier code before the function   
   modifier onlyOwner{
        require (owner == msg.sender, "Sender is not owner!");
        _; //the _ is a placeholder for any function that has this modifier
   }
}


// EXTRA N0TES: I dont fully understand why it doesnt work when i set mUsd = 50 * 1e18 and eAIUsd = (ePrice * eAmount)/1e18 
// Even though the value passed into eAmount should be in  wei and hence the final result too in wei.    