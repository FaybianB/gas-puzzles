// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedDistribute {
    /*
     * [
         0x0000000000000000000000000000000000000001,
         0x0000000000000000000000000000000000000002,
         0x0000000000000000000000000000000000000003,
         0x0000000000000000000000000000000000000004
        ]
     */
    address payable immutable contributorOne;
    address payable immutable contributorTwo;
    address payable immutable contributorThree;
    address payable immutable contributorFour;

    uint256 immutable distributeTime = block.timestamp + 1 weeks;
    // Perform bitwise division to divide by 4 (Shifting 2 bits to the right)
    uint256 immutable distributionAmount = address(this).balance >> 2;

    constructor(address[4] memory _contributors) payable {
        contributorOne = payable(_contributors[0]);
        contributorTwo = payable(_contributors[1]);
        contributorThree = payable(_contributors[2]);
        contributorFour = payable(_contributors[3]);
    }

    function distribute() external {
        require(block.timestamp > distributeTime, "cannot distribute yet");
        
        bool sentOne = contributorOne.send(distributionAmount);
        bool sentTwo = contributorTwo.send(distributionAmount);
        bool sentThree = contributorThree.send(distributionAmount);

        require(sentOne && sentTwo && sentThree);

        selfdestruct(contributorFour);
    }
}