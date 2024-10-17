# Version 5.2
@show 1 & 2   # AND
@show 1 | 2   # OR
@show 1 ^ 2   # XOR -- for Julia 6.0 the operator is `⊻`
@show ~1      # NOT
@show 1 >>> 2 # SHIFT RIGHT (LOGICAL)
@show 1 >> 2  # SHIFT RIGHT (ARITMETIC)
@show 1 << 2  # SHIFT LEFT (ARITMETIC/LOGICAL)

A = BitArray([true, true, false, false, true])
@show A ror(A,1) ror(A,2) ror(A,5) # ROTATION RIGHT
@show rol(A,1) rol(A,2) rol(A,5) # ROTATION LEFT
