pell(n::Integer) = last(BigInt[2 1; 1 0] ^ n * BigInt[1, 0])
pelllucas(n::Integer) = last(BigInt[2 1; 1 0] ^ n * BigInt[2, 2])
