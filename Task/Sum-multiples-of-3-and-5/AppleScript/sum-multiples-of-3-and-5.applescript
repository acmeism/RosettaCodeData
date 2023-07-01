----------------- SUM MULTIPLES OF 3 AND 5 -----------------

-- sum35 :: Int -> Int
on sum35(n)
    tell sumMults(n)
        |λ|(3) + |λ|(5) - |λ|(15)
    end tell
end sum35



-- sumMults :: Int -> Int -> Int
on sumMults(n)
    -- Area under straight line
    -- between first multiple and last.
    script
        on |λ|(m)
            set n1 to (n - 1) div m
            m * n1 * (n1 + 1) div 2
        end |λ|
    end script
end sumMults


--------------------------- TEST ---------------------------
on run
    -- sum35Result :: String -> Int -> Int -> String
    script sum35Result
        -- sums of all multiples of 3 or 5 below or equal to N
        -- for N = 10 to N = 10E8 (limit of AS integers)
        on |λ|(a, x, i)
            a & "10<sup>" & i & "</sup> -> " & ¬
                sum35(10 ^ x) & "<br>"
        end |λ|
    end script
    foldl(sum35Result, "", enumFromTo(1, 8))
end run


-------------------- GENERIC FUNCTIONS ---------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end enumFromTo

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn
