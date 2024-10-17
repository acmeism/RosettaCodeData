collect(-2:1:2)   # → [-2, -1, 0, 1, 2]
collect(-2:0:2)   # fails
collect(-2:-1:2)  # → []
collect(-2:10:2)  # → [-2]
collect(2:1:-2)   # → []
collect(2:1:2)    # → [2]
collect(2:-1:2)   # → [2]
collect(2:0:2)    # fails
collect(0:0:0)    # fails
