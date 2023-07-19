***Storage Overview

**Gas Costs
- Storage opcodes cost significantly more than most opcodes
- Setting storage 0 to non-zero costs 20,000 gas (Gsset)
- Setting storage from non-zero to non-zero costs 5,000 gas
- Setting storage from non-zero to zero results in a refund (Rsclear)
- Rsclear: Refund given (added into refund counter) when the storage value is set to zero from non-zero
- An additional 2,100 gas is paid if accessing a variable for the first time in a transaction (cold storage access fee)
- An additional 100 gas is paid if the variable has already been touched / accessed (Gwarmaccess)

**More On 5,000 Gas Non-Zero To Non-Zero
- 2,900 (Gsreset) + 2,100 (Gcoldsload) = 5,000
- Gcoldsload: Cost of a cold storage access.
- Gsreset: Paid for an SSTORE operation when the storage value’s zeroness remains unchanged or is set to zero

**Unchanged Storage Values
- Setting a storage variable to the same value that is currently stored in storage will cost 100 gas (Gwarmaccess)
- Gwarmaccess: Cost of a warm account or storage access

***Refunds And Setting To Zero Part 1
- Still have to pay the 5,000 gas when setting a variable from non-zero to zero (Gcoldsload + Gsreset)
- Cannot get the maximum refund of 15,000 gas, if the transaction costs less than 30,000 gas
- NOTE: These numbers were prior to EIP-3529 which went live in London upgrade and reduced amount of maximum refund from
15,000 to 4,800. Also, the maximum refund changed from 1/2 of gas cost to 1/5 of gas cost.

***Refunds And Setting To Zero Part 2
- Setting to zero can cost between 200 and 5,000 gas, depending on the eligible refund amount.
- Deleting an array (or setting many values to zero) can be expensive. Beware of the 20% rule.
- Setting one variable to zero is okay. Setting several variables to zero is like doing several non-zero to non-zero operations.
- For every zero operation, try to spend 24,000 gas elsewhere (tx cost, or setting zero to non-zero).
- Counting down is more efficient than counting up.

###Storage Cost For Files
- (KB (1 KB = 32 words (1 word = 32 bytes)) x words x Gas per 32 bytes (zero to non-zero) x Gas price (gwei) x Eth price) / 1 billion

###Structs And Strings Part 1
- The gas cost of a struct is the sum of all of the 32-byte values that it uses and the manner in which they are used.
- Structs try to pack their variables.
- Generally, more opcodes are required when using uint types smaller than `256` because Solidity may have to unpack the variables in their slots.
- 


