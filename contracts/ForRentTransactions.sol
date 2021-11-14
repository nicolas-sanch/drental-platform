// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ForRentFactory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ForRentTransactions is ForRentFactory {
    IERC20 public drentalToken;

    constructor(address _drentalTokenAddress) public {
        drentalToken = IERC20(_drentalTokenAddress);
    }

    function reserve(uint256 _forRentId) external {
        //Declare forRent element
        ForRent storage forRent = forRentArray[_forRentId];

        //Check if forRent element isn't already reservated
        require(!forRent.reservated, "Oups, already reservated!");

        // Compute the reservation percentage
        uint256 amountExpected = (forRent.price * reservationPercentage) / 100;

        // Check that the user's token balance is enough to do the reservation
        uint256 renterBalance = drentalToken.balanceOf(msg.sender);
        require(
            renterBalance >= amountExpected,
            "Your balance is lower than the amount of tokens needed to reserve"
        );

        // Transaction from renter to owner
        require(
            drentalToken.allowance(msg.sender, address(this)) >= amountExpected,
            "DRTToken allowance too low"
        );
        bool sent = drentalToken.transferFrom(
            msg.sender,
            forRentToOwner[_forRentId],
            amountExpected
        );
        require(sent, "Failed to transfer tokens from renter to owner");

        // forRent element is now reservated and have a renter
        forRent.reservated = true;
        forRentToRenter[_forRentId] = msg.sender;
    }

    function cancelReservation(uint256 _forRentId) external {
        //Declare forRent element
        ForRent storage forRent = forRentArray[_forRentId];

        //Check if forRent element is reservated
        require(forRent.reservated, "Oups, it isn't reservated!");

        //Check if user is the owner
        require(
            forRentToOwner[_forRentId] == msg.sender,
            "Only the owner can cancel the reservation"
        );

        // Compute the reservation percentage
        uint256 amountExpected = (forRent.price * reservationPercentage) / 100;

        // Check that the user's token balance is enough to refund the reservation
        uint256 renterBalance = drentalToken.balanceOf(msg.sender);
        require(
            renterBalance >= amountExpected,
            "Your balance is lower than the amount of tokens needed to refund the reservation"
        );

        // Transaction from owner to renter
        require(
            drentalToken.allowance(msg.sender, address(this)) >= amountExpected,
            "DRTToken allowance too low"
        );
        bool sent = drentalToken.transferFrom(
            msg.sender,
            forRentToRenter[_forRentId],
            amountExpected
        );
        require(sent, "Failed to transfer tokens from owner to renter");
        // Now, forRent element isn't reservated and don't have renter
        forRent.reservated = false;
        forRentToRenter[_forRentId] = address(
            0x0000000000000000000000000000000000000000
        );
    }

    function paid(uint256 _forRentId) external {
        //Declare forRent element
        ForRent storage forRent = forRentArray[_forRentId];

        //Check if forRent element is reservated, not already paid and user is renter
        require(forRent.reservated, "Oups, need to reserve first");
        require(!forRent.paid, "Oups, already paid");
        require(
            msg.sender == forRentToRenter[_forRentId],
            "Oups, it's reservated by another renter"
        );

        // Compute price minus reservation percentage
        uint256 amountExpected = forRent.price -
            ((forRent.price * reservationPercentage) / 100);

        // Check that the user's token balance is enough to do the reservation
        uint256 renterBalance = drentalToken.balanceOf(msg.sender);
        require(
            renterBalance >= amountExpected,
            "Your balance is lower than the amount of tokens needed to paid"
        );

        // Transaction from renter to owner
        require(
            drentalToken.allowance(msg.sender, address(this)) >= amountExpected,
            "DRTToken allowance too low"
        );
        bool sent = drentalToken.transferFrom(
            msg.sender,
            forRentToOwner[_forRentId],
            amountExpected
        );
        require(sent, "Failed to transfer tokens from renter to owner");

        // forRent element is now paid
        forRent.paid = true;
    }
}
