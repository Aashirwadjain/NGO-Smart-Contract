// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract NGO {

    address public admin;

    mapping(address => uint) private donations;
    address[] private donors;
    address public childrenWallet;

    event DonationReceived(address indexed donor, uint256 amount);
    event FundsTransferred(address indexed childrenWallet, uint256 amount);

    constructor(address _childrenWallet) {
        admin = msg.sender;
        childrenWallet = _childrenWallet;
    }

    modifier onlyOwner() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // Function to allow donors to contribute
    function donate() external payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        
        if (donations[msg.sender] == 0) {
            donors.push(msg.sender);
        }
        donations[msg.sender] += msg.value;

        emit DonationReceived(msg.sender, msg.value);
    }

    function getDonationByDonor(address donor) external view returns (uint256) {
        return donations[donor];
    }

    function getDonors() external view returns (address[] memory) {
        return donors;
    }

    function transferFunds() external onlyOwner {

        uint totalFunds = address(this).balance;
        require(totalFunds > 0, "No funds available for transfer");

        payable(childrenWallet).transfer(totalFunds);

        emit FundsTransferred(childrenWallet, totalFunds);
    }

}
