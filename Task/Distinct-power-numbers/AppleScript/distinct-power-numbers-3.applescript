use framework "Foundation"
use scripting additions


------------------ DISTINCT POWER VALUES -----------------

-- distinctPowers :: [Int] -> [Int]
on distinctPowers(xs)
    script powers
        on |λ|(a, x)
            script integerPower
                on |λ|(b, y)
                    b's addObject:((x ^ y) as integer)
                    b
                end |λ|
            end script

            foldl(integerPower, a, xs)
        end |λ|
    end script

    sort(foldl(powers, ¬
        current application's NSMutableSet's alloc's init(), xs)'s ¬
        allObjects())
end distinctPowers


--------------------------- TEST -------------------------
on run
    distinctPowers(enumFromTo(2, 5))
end run


------------------------- GENERIC ------------------------

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


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


-- sort :: Ord a => [a] -> [a]
on sort(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort
