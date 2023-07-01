on run
    take(25, weirds())
    -- Gets there, but takes about 6 seconds on this system,
    -- (logging intermediates through the Messages channel, for the impatient :-)
end run


-- weirds :: Gen [Int]
on weirds()
    script
        property x : 1
        property v : 0
        on |λ|()
            repeat until isWeird(x)
                set x to 1 + x
            end repeat
            set v to x
            log v
            set x to 1 + x
            return v
        end |λ|
    end script
end weirds

-- isWeird :: Int -> Bool
on isWeird(n)
    set ds to descProperDivisors(n)
    set d to sum(ds) - n
    0 < d and not hasSum(d, ds)
end isWeird

-- hasSum :: Int -> [Int] -> Bool
on hasSum(n, xs)
    if {} ≠ xs then
        set h to item 1 of xs
        set t to rest of xs
        if n < h then
            hasSum(n, t)
        else
            n = h or hasSum(n - h, t) or hasSum(n, t)
        end if
    else
        false
    end if
end hasSum

-- GENERIC ------------------------------------------------

-- descProperDivisors :: Int -> [Int]
on descProperDivisors(n)
    if n = 1 then
        {1}
    else
        set realRoot to n ^ (1 / 2)
        set intRoot to realRoot as integer
        set blnPerfect to intRoot = realRoot

        -- isFactor :: Int -> Bool
        script isFactor
            on |λ|(x)
                n mod x = 0
            end |λ|
        end script

        -- Factors up to square root of n,
        set lows to filter(isFactor, enumFromTo(1, intRoot))

        -- and cofactors of these beyond the square root,

        -- integerQuotient :: Int -> Int
        script integerQuotient
            on |λ|(x)
                (n / x) as integer
            end |λ|
        end script

        set t to rest of lows
        if blnPerfect then
            set xs to t
        else
            set xs to lows
        end if
        map(integerQuotient, t) & (reverse of xs)
    end if
end descProperDivisors

-- enumFromTo :: (Int, Int) -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        return lst
    else
        return {}
    end if
end enumFromTo

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
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

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- sum :: [Num] -> Num
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(add, 0, xs)
end sum

-- take :: Int -> Gen [a] -> [a]
on take(n, xs)
    set ys to {}
    repeat with i from 1 to n
        set v to xs's |λ|()
        if missing value is v then
            return ys
        else
            set end of ys to v
        end if
    end repeat
    return ys
end take

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn
