--------------- WATER COLLECTED BETWEEN TOWERS -------------

-- waterCollected :: [Int] -> Int
on waterCollected(xs)
    set leftWalls to scanl1(my max, xs)
    set rightWalls to scanr1(my max, xs)

    set waterLevels to zipWith(my min, leftWalls, rightWalls)

    -- positive :: Num a => a -> Bool
    script positive
        on |λ|(x)
            x > 0
        end |λ|
    end script

    -- minus :: Num a => a -> a -> a
    script minus
        on |λ|(a, b)
            a - b
        end |λ|
    end script

    sum(filter(positive, zipWith(minus, waterLevels, xs)))
end waterCollected


---------------------------- TEST --------------------------
on run
    map(waterCollected, ¬
        [[1, 5, 3, 7, 2], ¬
            [5, 3, 7, 2, 6, 4, 5, 9, 1, 2], ¬
            [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1], ¬
            [5, 5, 5, 5], ¬
            [5, 6, 7, 8], ¬
            [8, 7, 7, 6], ¬
            [6, 7, 10, 7, 6]])

    --> {2, 14, 35, 0, 0, 0, 0}
end run


--------------------- GENERIC FUNCTIONS --------------------

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

-- init :: [a] -> [a]
on init(xs)
    if length of xs > 1 then
        items 1 thru -2 of xs
    else
        {}
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

-- max :: Ord a => a -> a -> a
on max(x, y)
    if x > y then
        x
    else
        y
    end if
end max

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
        scanl(f, item 1 of xs, items 2 thru -1 of xs)
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
        scanr(f, item -1 of xs, items 1 thru -2 of xs)
    else
        {}
    end if
end scanr1

-- sum :: Num a => [a] -> a
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(add, 0, xs)
end sum

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys)
        end repeat
        return lst
    end tell
end zipWith
