replicate(5000, "ha")

-- Repetition by 'Egyptian multiplication' -
-- progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for
-- binary assembly of a target length.

-- replicate :: Int -> String -> String
on replicate(n, s)
    set out to ""
    if n < 1 then return out
    set dbl to s

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate
