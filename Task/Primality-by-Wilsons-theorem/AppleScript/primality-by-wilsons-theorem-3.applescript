on isPrime(n)
    -- Check for numbers < 2 and 2 & 3 and their multiples.
    if (n < 4) then return (n > 1)
    if ((n mod 2 = 0) or (n mod 3 = 0)) then return false
    -- Only multiply numbers in the range √n -> n - √n that are 1 less and 1 more than multiples of 6,
    -- starting with a number that's 1 less than a multiple of 6 and as close as practical to √n.
    tell (n ^ 0.5 div 1) to set f to it - (it - 2) mod 6 + 3
    repeat with i from f to (n - f - 6) by 6
        set f to f * i mod n * (i + 2) mod n
        if (f = 0) then return false
    end repeat

    return true
end isPrime
