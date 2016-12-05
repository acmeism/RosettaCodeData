-- ORDINAL STRINGS

-- ordinalString :: Int -> String
on ordinalString(n)
    (n as string) & ordinalSuffix(n)
end ordinalString

-- ordinalSuffix :: Int -> String
on ordinalSuffix(n)
    set modHundred to n mod 100
    if (11 ≤ modHundred) and (13 ≥ modHundred) then
        "th"
    else
        item ((n mod 10) + 1) of ¬
            {"th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"}
    end if
end ordinalSuffix



-- TEST
on run

    -- showOrdinals :: [Int] -> [String]
    script showOrdinals
        on lambda(lstInt)
            map(ordinalString, lstInt)
        end lambda
    end script

    map(showOrdinals, ¬
        map(tupleRange, ¬
            [[0, 25], [250, 265], [1000, 1025]]))

end run



-- GENERIC FUNCTIONS

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to lambda(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- tupleRange :: (Int, Int) -> [Int]
on tupleRange(lstPair)
    set {m, n} to lstPair

    range(m, n)
end tupleRange

-- range :: Int -> Int -> [Int]
on range(m, n)
    if n < m then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property lambda : f
        end script
    end if
end mReturn
