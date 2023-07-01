------------------- MUNCHAUSEN NUMBER ? --------------------

-- isMunchausen :: Int -> Bool
on isMunchausen(n)

    -- digitPowerSum :: Int -> Character -> Int
    script digitPowerSum
        on |λ|(a, c)
            set d to c as integer
            a + (d ^ d)
        end |λ|
    end script

    (class of n is integer) and ¬
        n = foldl(digitPowerSum, 0, characters of (n as string))

end isMunchausen


--------------------------- TEST ---------------------------
on run

    filter(isMunchausen, enumFromTo(1, 5000))

    --> {1, 3435}

end run


-------------------- GENERIC FUNCTIONS ---------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        lst
    else
        {}
    end if
end enumFromTo

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(p, xs)
    tell mReturn(p)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter

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
