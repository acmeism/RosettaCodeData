-- sum35 :: Int -> Int
on sum35(n)
    sumMults(n, 3) + sumMults(n, 5) - sumMults(n, 15)
end sum35

-- Area under straight line between first multiple and last:

-- sumMults :: Int -> Int -> Int
on sumMults(n, f)
    set n1 to (n - 1) div f

    f * n1 * (n1 + 1) div 2
end sumMults


-- TEST
on run
    -- sums of all multiples of 3 or 5 below or equal to N
    -- for N = 10 to N = 10E8 (limit of AS integers)

    -- sum35Result :: String -> Int -> Int -> String
    script sum35Result
        on lambda(a, x, i)
            a & "10<sup>" & i & "</sup> -> " & ¬
                sum35(10 ^ x) & "<br>"
        end lambda
    end script

    foldl(sum35Result, "", range(1, 8))
end run



-- GENERIC LIBRARY FUNCTIONS

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to lambda(v, item i of xs, i, xs)
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
            property lambda : f
        end script
    end if
end mReturn

-- range :: Int -> Int -> [Int]
on range(m, n)
    set d to cond(n < m, -1, 1)
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range

-- cond :: Bool -> (a -> b) -> (a -> b) -> (a -> b)
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond
