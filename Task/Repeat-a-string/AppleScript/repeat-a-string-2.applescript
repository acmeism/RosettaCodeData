on run
    nreps("ha", 50000)
end run


-- String -> Int -> String
on nreps(s, n)
    set o to ""
    if n < 1 then return o

    repeat while (n > 1)
        if (n mod 2) > 0 then set o to o & s
        set n to (n div 2)
        set s to (s & s)
    end repeat
    return o & s
end nreps
