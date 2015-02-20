out?doors num
? Simulates the 100 doors problem for any number of doors
? Returns a boolean vector with 1 being open

out??num            ? num steps
out??¨out           ? Count out the spacing for each step
out?1=out           ? Make that into a boolean vector
out??¨out           ? Flip each vector around
out?(num°?)¨out     ? Copy each out to the right size
out??/out           ? XOR each vector, toggling each marked door
out??out            ? Disclose the results to get a vector
