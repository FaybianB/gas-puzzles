### Memory vs Calldata
- Memory is more expensive than calldata
- Calldata cannot be changed, so if the parameter ever needs to be mutated, it makes sense to store it in memory instead
- Calldata arrays are read-only

### Memory Is Never Cleared
- Solidity does not clear memory that it no longer uses (no garbage collector)
- Memory is never overwritten in Solidity when allocating memory
