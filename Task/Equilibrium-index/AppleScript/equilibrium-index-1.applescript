-- equilibriumIndices :: [Int] -> [Int]
on equilibriumIndices(xs)

    script balancedPair
        on |λ|(a, pair, i)
            set {x, y} to pair
            if x = y then
                {i - 1} & a
            else
                a
            end if
        end |λ|
    end script

    script plus
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    -- Fold over zipped pairs of sums from left
    -- and sums from right

    foldr(balancedPair, {}, ¬
        zip(scanl1(plus, xs), scanr1(plus, xs)))

end equilibriumIndices

-- TEST -----------------------------------------------------------------------
on run

    map(equilibriumIndices, {¬
        {-7, 1, 5, 2, -4, 3, 0}, ¬
        {2, 4, 6}, ¬
        {2, 9, 2}, ¬
        {1, -1, 1, -1, 1, -1, 1}, ¬
        {1}, ¬
        {}})

    --> {{3, 6}, {}, {1}, {0, 1, 2, 3, 4, 5, 6}, {0}, {}}
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

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

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldr

-- init :: [a] -> [a]
on init(xs)
    set lng to length of xs
    if lng > 1 then
        items 1 thru -2 of xs
    else if lng > 0 then
        {}
    else
        missing value
    end if
end init

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

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

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

-- scanl :: (b -> a -> b) -> b -> [a] -> [b]
on scanl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        set lst to {startValue}
        repeat with i from 1 to lng
            set v to |λ|(v, item i of xs, i, xs)
            set end of lst to v
        end repeat
        return lst
    end tell
end scanl

-- scanl1 :: (a -> a -> a) -> [a] -> [a]
on scanl1(f, xs)
    if length of xs > 0 then
        scanl(f, item 1 of xs, tail(xs))
    else
        {}
    end if
end scanl1

-- scanr :: (b -> a -> b) -> b -> [a] -> [b]
on scanr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        set lst to {startValue}
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
            set end of lst to v
        end repeat
        return reverse of lst
    end tell
end scanr

-- scanr1 :: (a -> a -> a) -> [a] -> [a]
on scanr1(f, xs)
    if length of xs > 0 then
        scanr(f, item -1 of xs, init(xs))
    else
        {}
    end if
end scanr1

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail

-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to {item i of xs, item i of ys}
    end repeat
    return lst
end zip
