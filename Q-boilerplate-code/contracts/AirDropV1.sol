// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity ^0.8.19;

import {MerkleWhitelisted} from "@dlsl/dev-modules/access-control/MerkleWhitelisted.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {TokenBalance} from "./libs/TokenBalance.sol";

contract AirDropV1 is MerkleWhitelisted, Ownable {
    // Rest of the code goes here
    event RewardClaimed(bytes32 indexed merkleRoot, address indexed account);
    event AirDropCreated(
        bytes32 indexed merkleRoot,
        address indexed rewardToken,
        uint256 rewardAmount
    );
    address public rewardToken;
uint256 public rewardAmount;
mapping(bytes32 => mapping(address => bool)) public isUserClaimed;

modifier onlyNotClaimed(address account_) {
    require(
        !isUserClaimed[getMerkleRoot()][account_],
        "AirDropV1: account already claimed reward."
    );
    _;
}

function create_airdrop(address rewardToken_, uint256 rewardAmount_, bytes32 merkleRoot_) public {
    _setMerkleRoot(merkleRoot_);
    rewardToken = rewardToken_;
    rewardAmount = rewardAmount_;
    emit AirDropCreated(merkleRoot_, rewardToken_, rewardAmount_);
}

function claimReward(address account_, bytes32[] calldata merkleProof_) external onlyWhitelistedUser(account_, merkleProof_) onlyNotClaimed(account_) {
    bytes32 merkleRoot_ = getMerkleRoot();
    isUserClaimed[merkleRoot_][account_] = true;
    TokenBalance.sendFunds(rewardToken, account_, rewardAmount);
    emit RewardClaimed(merkleRoot_, account_);
}
function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
    _setMerkleRoot(merkleRoot_);
}

}
