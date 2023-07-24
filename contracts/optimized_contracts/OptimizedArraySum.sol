// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

// 24764 gas (Remix)
// The byte code for this contract is smaller
// Remix says less gas is consumed
// Hardhat tests say this is 86 gas above the target
/*contract OptimizedArraySum {
    // Do not modify this
    uint256[] array;

    // Do not modify this
    function setArray(uint256[] memory _array) external {
        require(_array.length <= 10, 'too long');
        array = _array;
    }

    // optimize this function
    function getArraySum() external view returns (uint256) {
        uint256 slot;
        uint256 length;

        // Get the length of the array
        assembly {
            slot := array.slot
            length := sload(slot)
        }
        
        // Get the location in storage of the array's values
        bytes32 location = keccak256(abi.encode(slot));

        // [10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
        assembly {
            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                // Load the value at the array's index
                let valueToAdd := sload(add(location, i))
                let sum := add(mload(0x00), valueToAdd)
                
                // Check for overflow
                if lt(sum, valueToAdd) { revert(0, 0) }

                // Add the value to the sum and store it at 0x00 in memory
                mstore(0x00, add(mload(0x00), valueToAdd))
            }

            return(0x00, 0x20)
        }
    }
}*/

// Original: 30142 gas (Remix)
// This Solution: 30137 gas (Remix)
contract OptimizedArraySum {
    // Do not modify this
    uint256[] array;

    // Do not modify this
    function setArray(uint256[] memory _array) external {
        require(_array.length <= 10, 'too long');
        array = _array;
    }

    // optimize this function
    // Moving the 
    function getArraySum() external view returns (uint256 sum) {
        // Can save gas by removing this declaration and moving it to the returns() statement
        //uint256 sum;

        for (uint256 i = 0; i < array.length; i++) {
            sum += array[i];
        }

        // Can save gas by removing this statement since the variable being returned is already declared in the returns()
        //return sum;
    }
}