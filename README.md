# Passport Control System 

This Solidity smart contract, Passport control system, is designed to manage the creation, revocation, view and renewal of passports on the Ethereum blockchain.

## Description

The Passport control system Solidity smart contract is a decentralized system built on the Ethereum blockchain to manage the lifecycle of a travel passport, including creation, cancellation, view and renewal.

## Getting Started

In this assessment, I have used remix IDE [https://remix.ethereum.org/]

### Executing program


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract PassportManagement {

    enum PassportType { Regular, Diplomatic, Official }

    struct Passport {
        address owner;
        PassportType passportType;
        string name;
        string nationality;
        uint dateOfBirth;
        uint issueDate;
        uint expiryDate;
        bool isValid;
    }

    mapping(uint => Passport) public passports;
    uint public nextPassportId = 1;

    event PassportCreationAttempt(address owner, uint issueDate, uint expiryDate);

function createPassport(
    address _owner,
    PassportType _passportType,
    string memory _name,
    string memory _nationality,
    uint _dateOfBirth,
    uint _issueDate,
    uint _expiryDate
) public {
    emit PassportCreationAttempt(_owner, _issueDate, _expiryDate);
    require(_issueDate < _expiryDate, "Issue date must be before expiry date");

    passports[nextPassportId++] = Passport(
        _owner, 
        _passportType, 
        _name, 
        _nationality, 
        _dateOfBirth, 
        _issueDate, 
        _expiryDate, 
        true
    );
}


    function revokePassport(uint _passportId) public {
        Passport storage passport = passports[_passportId];
        // Check if passport exists and is valid
        require(passport.owner != address(0), "Passport does not exist");
        require(passport.isValid, "Passport is already invalid");
        require(passport.owner == msg.sender, "Unauthorized");

        passport.isValid = false;
    }

    function viewPassport(uint _passportId) public view returns (Passport memory) {
        Passport memory passport = passports[_passportId];
        // Check if passport exists and is valid
        require(passport.owner != address(0), "Passport does not exist");
        require(passport.isValid, "Passport is invalid");
        require(passport.owner == msg.sender || msg.sender == address(0), "Unauthorized"); // Example: Allow anyone to view valid passports

        return passport;
    }

    function renewPassport(uint _passportId, uint _newExpiryDate) public {
        Passport storage passport = passports[_passportId];
        // Check if passport exists and is valid
        require(passport.owner != address(0), "Passport does not exist");
        require(passport.isValid, "Invalid passport");
        require(passport.owner == msg.sender, "Unauthorized");
        require(_newExpiryDate > passport.expiryDate, "New expiry date must be after current expiry date");

        passport.expiryDate = _newExpiryDate;
    }
}

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.7" (or another compatible version), and then click on the "Compile AccountManagement.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "Passport Control System" contract from the dropdown menu, and then click on the "Deploy" button.

## Authors

Manish Kumar - (https://www.linkedin.com/in/manish-kmr/)


## License

This project is licensed under the MIT License
