// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedArraySort {
    function sortArray(uint256[] memory data) external pure returns (uint256[] memory) {
        // Stores the length of dynamic array
        // Possibly can delete this to save gas because the length is stored in the slot
        uint256 dataLen = data.length;
        bytes32 location;
        bytes32 valueAtIndexI;
        bytes32 valueAtIndexJ;

        for (uint256 i = 0; i < dataLen; i++) {
            for (uint256 j = i+1; j < dataLen; j++) {
                // [5, 4, 3, 2, 1]
                // Flips the values in the new array by comparing the current value index with the value at the next index
                assembly {
                    // Return the location of the array in memory
                    location := data
                    // Jump over the array's length value to get the elements
                    // Multiply by 32 (bytes) to get the value in the next slot
                    // Adds 1 to the indexes i and j because the first value of the array is the length
                    let indexI := add(data, mul(32, add(i, 1)))
                    let indexJ := add(data, mul(32, add(j, 1)))
                    valueAtIndexI := mload(indexI)
                    valueAtIndexJ := mload(indexJ)
                
                    if gt(valueAtIndexI, valueAtIndexJ) {
                        mstore(indexI, valueAtIndexJ)
                        mstore(indexJ, valueAtIndexI)
                    }
                }
            }
        }
        
        return data;
    }
}
