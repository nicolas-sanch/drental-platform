// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForRentFactory {
    uint8 reservationPercentage = 20;

    struct ForRent {
        uint256 forRentId;
        string name;
        address lockBoxAddress;
        uint256 price;
        bool reservated;
        bool paid;
    }

    ForRent[] public forRentArray;
    // forRentId => ownerAddress
    mapping(uint256 => address) public forRentToOwner;
    // forRentId => renterAddress
    mapping(uint256 => address) public forRentToRenter;

    function _createForRent(
        string memory _name,
        address _lockBoxAddress,
        uint256 _price
    ) public {
        forRentArray.push(
            ForRent(
                forRentArray.length,
                _name,
                _lockBoxAddress,
                _price,
                false,
                false
            )
        );
        forRentToOwner[forRentArray.length - 1] = msg.sender;
    }

    function _freeForRent(uint256 _forRentId) public {
        //Declare forRent
        ForRent storage forRent = forRentArray[_forRentId];

        //Check if user is the owner
        require(
            forRentToOwner[_forRentId] == msg.sender,
            "Only owner can free"
        );

        //Free
        forRent.reservated = false;
        forRent.paid = false;
        forRentToRenter[_forRentId] = address(
            0x0000000000000000000000000000000000000000
        );
    }
}
