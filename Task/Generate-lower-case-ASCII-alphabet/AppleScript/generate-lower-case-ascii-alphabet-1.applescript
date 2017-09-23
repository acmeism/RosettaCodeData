on run

    {enumFromTo("a", "z"), ¬
        enumFromTo("🐐", "🐟")}

end run

-- GENERIC FUNCTIONS ----------------------------------------------------------

-- chr :: Int -> Char
on chr(n)
    character id n
end chr

-- ord :: Char -> Int
on ord(c)
    id of c
end ord

-- enumFromTo :: Enum a => a -> a -> [a]
on enumFromTo(m, n)
    set {intM, intN} to {fromEnum(m), fromEnum(n)}

    if intM > intN then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    if class of m is text then
        repeat with i from intM to intN by d
            set end of lst to chr(i)
        end repeat
    else
        repeat with i from intM to intN by d
            set end of lst to i
        end repeat
    end if
    return lst
end enumFromTo

-- fromEnum :: Enum a => a -> Int
on fromEnum(x)
    set c to class of x
    if c is boolean then
        if x then
            1
        else
            0
        end if
    else if c is text then
        if x ≠ "" then
            id of x
        else
            missing value
        end if
    else
        x as integer
    end if
end fromEnum
