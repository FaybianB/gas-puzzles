### Function Names
- When a function is called, Solidity basically does a switch statement to match each function's selector with the one in calldata to determine which code
to run.
- Solidity compiler sorts the checks by the hexadecimal order of the function selector.
- For gas-sensitive functions, it's beneficial to ensure their function selectors are near the top of this sort order.
- When benchmarking a function to optimize gas cost, shouldn't change the function name because it'd be unclear if the results are due to the function name
change or the changes made inside the function.

### Less Than vs Less Than Or Equal To
- There are no opcodes that correlate with "less than or equal to" or "greater than or equal to" operations.
- Solidity will perform multiple opcodes in order to do the comparison and this costs more gas.
- "less than" and "greater than" operations are always more gas efficient than "less than or equal to" or "greater than or equal to" operations.

### Bit Shifting
- Multiplication and division operations can be accomplished by bit shifting in Solidity.
- There are no overflow or underflow checks when bit shifting.
- Shift left for multiplication, shift right for division.
- Solidity does not do floating point division, thus, 5 / 2 = 2.
- For multiplication, check if the result is greater than x.

### Revert Early
- Ethereum transactions that revert still have to pay gas.
- If revert occurs due to hitting gas limit ("out of gas"), user pays full gas cost.
- If revert occurs due to a REVERT opcode, they only pay gas up to that point.
- It saves the user gas to revert as early as possible in the transaction.

### Short Circuiting
- Solidity shortcut evaluates AND and OR operators.
- If there's a substantial difference in gas costs between X and Y during these operations, it's oftern worthwhile to put the cheaper operation first.

### Precomputing
- Cannot always rely on Solidity compiler to carry out constant expressions and store the result in the compilation output.
