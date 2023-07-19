### Calculating The Cost of An Ethereum Transfer
- Transaction Fee = (Gas Usage x Gas Price) / 1 billion
- Dollar Amount = (Transaction Fee) x (Current Ether price)
- Gas price is given in units of gwei (1 billionth of an Ether)
- Transferring Ethereum always costs 21,000 gas
- Gas price changes depending on network conditions and is how much miners are paid to mine the transaction
- Etherscan.io/gastracker for current gas price

### Heavy And Light Functions
- All transactions on Ethereum must cost at least 21,000 gas

## Block Limit

### Block Limits
- Bitcoin has historically limited the block size to 1 MB
- If the block is too big, it may become too expensive to store or synchronize with other nodes across the world
- Ethereum does not explicitly set a byte limit to the block size
- Instead, Ethereum limits the amount of computations per block, or gas
- Each computation has a gas cost
- The sum of all the gas costs of all the transactions in a single block need to fall below a certain number
- If a block has too much computation on it, it will be difficult for nodes to verify the transactions quickly
- At the time of recording, the block limit is 30 million gas
- An eth transfer costs 21,000 gas, so theoretically one block can hold 1,428 transfers (30 million / 21,000)
- On the other extreme, if everyone is using tornado cash, which costs almost one million gas per transaction, only 30 transfers will fit

### Throughput
- Measured in transactions per second
- A new block is generated every 15 seconds on Ethereum
- The transaction throughput will be between 2 (following Tornado Cash example, 30 transactions in a block / 15 seconds) and 95 (following
the eth transfer example, 1,428 transactions in a block / 15 seconds) transactions per second (tps)
- Ethereum has been doing on average 13 tps at the time of recording

### Implications
- There cannot be more than 1,428 transfers on one block. If more than 1,428 people are trying to make a transfer, then the highest bidder
will have their transaction included on the block. This is why gas prices fluctuate.
- 21,000 in isolation might seem like an arbitrary number, but you concretely think of it as being 0.07% of Ethereum's computational capacity
per 15 seconds.
- If your smart contract requires over 30 million gas to execute, it won't fit on the block.

### Important
- 30 million is not a hard limit. The gas limit changes and is not completely static.
- Ethereum technically has a preferred block limit and dynamic block limit but conceptually, you can just think of it as 30 million gas
- A future hard fork may change this number

### Opcode Gas Cost
- A significant amount of the gas cost of a transaction is simply the sum of the opcodes that are executed within that transaction

### Summary: There Are 5 Places To Save Gas
- On Deployment: The smaller the contract, the less gas you pay on deployment
- During Computation: Using fewer or cheaper opcodes saves gas on execution
- Transaction Data: The larger the transaction data, and the more non-zero bytes it contains, the more gas it costs
- Memory: The more memory allocated, even if it's not used, results in a higher gas cost
- Storage: The more storage used, the higher the gas cost

### Non-Payable Functions
- All else equal, Non-payable functions cost more gas to execute because it first checks if a call value (ether) was sent equals 0 and if not, it'll revert
- Payable functions don't have this check, therefore, has less opcodes and less cost to deploy

### Unchecked Arithmetic Part 2
- Since Solidity 0.8.0, arithmetic checks were added to check for overflows and underflows
- These extra checks result in more opcodes
- Calculations inside of unchecked blocks don't include these safety parameters resulting in fewer opcodes and cheaper gas
- Thus, doing arithmetic operations that are unlikely to cause an overflow or underflow, such as incrementing a counter, in
unchecked blocks is more gas efficient

### Gas Limit And More On 21,000 Gas
- Gas Limit is the maximum amount of gas paid for the transaction
- If the gas to execute the transaction exceeds the gas the limit, the transaction will revert
- A minimum of 21,000 gas is required to execute any transaction, to cover the gas costs to ensure:
    (1) The transaction is well-formed RLP, with no additional trailing bytes;
    (2) the transaction signature is valid;
    (3) the transaction nonce is valid (equivalent to the sender account’s current nonce);
    (4) the sender account has no contract code deployed;
    (5) the gas limit is no smaller than the intrinsic gas used by the transaction; and
    (6) the sender account balance contains at least the cost required in up-front payment.

## EIP 1559 Part 1
- Prior to EIP 1559, the entirety of the gas fee would go to the miners
- Post EIP-1559, a portion of the gas fee is burned

### The EIP-1559 Has Only Two Fees And One Global Variable
- `max_priority_fee_per_gas` and `max_fee_per_gas`
- `max_fee_per_gas` is the most gwei per gas a user is willing to pay
- `max_priority_fee_per_gas` is what portion of that `max_fee_per_gas` the user wants to be a miner tip
- There is also a protocol-level `BASEFEE` (defined by the protocol and not the user) which determines how much is going to be burned

### BASEFEE
- BASEFEE is the protocol-level base fee
- This is visible on every block
- BASEFEE is burned
- VERY ROUGHLY it increases by 12% if the last block was full and decreases by 12% if the last block was empty
- Exact formula is complicated
- Solidity ^0.8.7 block

### Max Base Fee
- For a transaction to go through, max fee >= BASEFEE
- Because BASEFEE can fluctuate, the protocol BASEFEE might exceed basefee paid when the transaction was signed
- So the user doesn't specify a base fee but how high of a base fee they are willing to pay at most. If the next block increases the base
fee because the previous block was full, the max base fee should be set high enough to account for this contingency.

### Max Priority Fee
- Max priority fee = max priority fee specified in the transaction
- priority fee = amount miner actually received. Also known as minter tip.

## EIP 1559 Part 2

### Priority Fee
- Max Fee - BASEFEE = leftover
    - Case 1: max_priority_fee < leftover: leftover - max_priority_fee = refund
    - Case 2: max_priority_fee >= leftover: refund = 0, miner gets leftover
- if max_priority_fee > leftover -> refund = 0
    - tx fee = BASEFEE + (max_fee - max_priority_fee)
    - tx fee = BASEFEE + miner tip
- if max_priority_fee < leftover -> refund > 0
    - tx fee = burned fee (BASEFEE) + max_priority_fee

### Conclusion
- BASEFEE = amount burned. This is determined by the network.
- Max Fee = Most you are willing to pay for the transaction, independent of the priority fee. This is the upper bound of the gas price your transaction
will pay.
- Max Priority Fee = The most you are willing to give to the miner.
- Miner tip / Priority Fee = The amount the miner actually recieves. The miner will receive less than the max priority fee if max_fee - BASEFEE < max_priority_fee

### Solidity Optimizer
- When deploying contracts, one should test how high to set the optimizer before the bytecode increases
- The higher the number of runs in the optimizer, the smaller the bytecode (up to a certain point)
- Lower amount of runs makes deployment costs cheaper higher transaction costs for the users
