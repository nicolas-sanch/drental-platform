# Drental platform

Welcome to the Drental platform repository!
<br/>
Born during the [Chainlink Fall 2021 HACKATHON](https://chain.link/hackathon), the first idea was to implement skills obtain after following the [Solidity, Blockchain, and Smart Contract Course](https://www.youtube.com/watch?v=M576WGiDBdQ) 👨🏻‍🎓

## A platform for what ?
As an owner (flat, car, etc...), I want: 
* to rent my property with a _smart contract_ as a "trusted tier",
* to give access to my property keys with a _connected key lock boxes_ 🔐.

As a renter, I want:
* to reserve, fo rent a property
* paid, which will give me access to the key in the _connected key lock boxes_ 👌

As an investor, I want:
* exchange the platform token (DRTT) with others cryptocurrencies
* stake DRTT and receive rewards from the platform transactions fees

## Getting started

1. Clone the repo
```sh
git clone https://github.com/nicolas-sanch/drental-platform
cd drental-platform
git submodule update --init
```

2. Deploy the contracts
```sh
brownie run scripts/deploy.py --network kovan
```

## Deployed Contracts / Hash

DRTToken deployed at: https://kovan.etherscan.io/address/0xa9940cACDd09a29DcA6662420b747d5b3a0dD867
</br>
ForRentTransactions deployed at: https://kovan.etherscan.io/address/0x5b2FDF311d06A2D30ba7997C866F921e0E346136