on bitwiseAND(n1, n2, registerSize)
    set out to 0
    -- Multiplying equivalent bit values by each other gives 1 where they're both 1 and 0 otherwise.
    repeat with i from 0 to registerSize - 1
        tell (2 ^ i) to set out to out + (n1 div it) * (n2 div it) mod 2 * it
    end repeat

    return out div 1
end bitwiseAND

on bitwiseOR(n1, n2, registerSize)
    set out to 0
    -- Adding bit values plus a further 1 gives a carry of 1 if either or both values are 1, but not if they're both 0.
    repeat with i from 0 to registerSize - 1
        tell (2 ^ i) to set out to out + (n1 div it mod 2 + n2 div it mod 2 + 1) div 2 * it
    end repeat

    return out div 1
end bitwiseOR

on bitwiseXOR(n1, n2, registerSize)
    set out to 0
    -- Adding bit values gives 1 if they're different and 0 (with or without a carry) if they're both the same.
    repeat with i from 0 to registerSize - 1
        tell (2 ^ i) to set out to out + (n1 div it + n2 div it) mod 2 * it
    end repeat

    return out div 1
end bitwiseXOR

on bitwiseNOT(n, registerSize)
    -- Subtract n from an all-1s value (ie. from 1 less than 2 ^ registerSize).
    tell (2 ^ registerSize) to return (it - 1 - n mod it) div 1
end bitwiseNOT

on leftShift(n, shift, registerSize)
    -- Multiply by 2 ^ shift and lose any bits beyond the left of the register.
    return n * (2 ^ shift) mod (2 ^ registerSize) div 1
end leftShift

on rightShift(n, shift, registerSize)
    -- Divide by 2 ^ shift and lose any bits beyond the right of the register.
    return n mod (2 ^ registerSize) div (2 ^ shift)
end rightShift

on arithmeticRightShift(n, shift, registerSize)
    set n to n mod (2 ^ registerSize)
    -- If the number's positive and notionally sets the sign bit, reinterpret it as a negative.
    tell (2 ^ (registerSize - 1)) to if (n ≥ it) then set n to n mod it - it
    -- Right shift by the appropriate amount
    set out to n div (2 ^ shift)
    -- If the result for a negative is 0, change it to -1.
    if ((n < 0) and (out is 0)) then set out to -1
    return out
end arithmeticRightShift

on leftRotate(n, shift, registerSize)
    -- Cut the register at the appropriate point, left shift the right side and right shift the left by the appropriate amounts.
    set shift to shift mod (registerSize)
    return leftShift(n, shift, registerSize) + rightShift(n, registerSize - shift, registerSize)
end leftRotate

on rightRotate(n, shift, registerSize)
    -- As left rotate, but applying the shift amounts to the opposite sides.
    set shift to shift mod registerSize
    return rightShift(n, shift, registerSize) + leftShift(n, registerSize - shift, registerSize)
end rightRotate

bitwiseAND(92, 7, 16) --> 4
bitwiseOR(92, 7, 16) --> 95
bitwiseXOR(92, 7, 16) --> 91
bitwiseNOT(92, 16) --> 64453
bitwiseNOT(92, 8) --> 163
bitwiseNOT(92, 32) --> 4.294967203E+9
leftShift(92, 7, 16) --> 11776
leftShift(92, 7, 8) --> 0
rightShift(92, 7, 16) --> 0
arithmeticRightShift(92, 7, 16) --> 0
arithmeticRightShift(-92, 7, 16) --> -1
leftRotate(92, 7, 8) --> 46
rightRotate(92, 7, 8) --> 184
rightRotate(92, 7, 16) --> 47104
