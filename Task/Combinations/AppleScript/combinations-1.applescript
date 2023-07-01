on comb(n, k)
    set c to {}
    repeat with i from 1 to k
        set end of c to i's contents
    end repeat
    set r to {c's contents}
    repeat while my next_comb(c, k, n)
        set end of r to c's contents
    end repeat
    return r
end comb

on next_comb(c, k, n)
    set i to k
    set c's item i to (c's item i) + 1
    repeat while (i > 1 and c's item i ≥ n - k + 1 + i)
        set i to i - 1
        set c's item i to (c's item i) + 1
    end repeat
    if (c's item 1 > n - k + 1) then return false
    repeat with i from i + 1 to k
        set c's item i to (c's item (i - 1)) + 1
    end repeat
    return true
end next_comb

return comb(5, 3)
