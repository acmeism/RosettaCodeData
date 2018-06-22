on run

    {enumFromTo("a", "z"), ¬
        enumFromTo("🐐", "🐟")}

end run

-- GENERIC FUNCTIONS ---------------------------------------------------------

-- enumFromTo :: Enum a => a -> a -> [a]
on enumFromTo(m, n)
    if class of m is integer then
        enumFromToInt(m, n)
    else
        enumFromToChar(m, n)
    end if
end enumFromTo

-- enumFromToChar :: Char -> Char -> [Char]
on enumFromToChar(m, n)
    set {intM, intN} to {id of m, id of n}
    set xs to {}
    repeat with i from intM to intN by signum(intN - intM)
        set end of xs to character id i
    end repeat
    return xs
end enumFromToChar

-- signum :: Num -> Num
on signum(x)
    if x < 0 then
        -1
    else if x = 0 then
        0
    else
        1
    end if
end signum
