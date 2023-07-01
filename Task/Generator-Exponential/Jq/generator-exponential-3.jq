# Generate the first 4 values in the sequence i^2:
[0,0] | emit(4; next_power(2)) | .[1]

# Generate all the values in the sequence i^3 less than 100:
[0,0] | recurse(next_power(3) | if .[1] < 100 then . else empty end) | .[1]
