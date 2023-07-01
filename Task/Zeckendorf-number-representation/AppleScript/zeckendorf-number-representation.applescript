--------------------- ZECKENDORF NUMBERS -------------------

-- zeckendorf :: Int -> String
on zeckendorf(n)
    script f
        on |λ|(n, x)
            if n < x then
                [n, 0]
            else
                [n - x, 1]
            end if
        end |λ|
    end script

    if n = 0 then
        {0} as string
    else
        item 2 of mapAccumL(f, n, |reverse|(just of tailMay(fibUntil(n)))) as string
    end if
end zeckendorf

-- fibUntil :: Int -> [Int]
on fibUntil(n)
    set xs to {}
    set limit to n

    script atLimit
        property ceiling : limit
        on |λ|(x)
            (item 2 of x) > (atLimit's ceiling)
        end |λ|
    end script

    script nextPair
        property series : xs
        on |λ|([a, b])
            set nextPair's series to nextPair's series & b
            [b, a + b]
        end |λ|
    end script

    |until|(atLimit, nextPair, {0, 1})
    return nextPair's series
end fibUntil

---------------------------- TEST --------------------------
on run

    intercalate(linefeed, ¬
        map(zeckendorf, enumFromTo(0, 20)))

end run

--------------------- GENERIC FUNCTIONS --------------------

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

-- 'The mapAccumL function behaves like a combination of map and foldl;
-- it applies a function to each element of a list, passing an
-- accumulating parameter from left to right, and returning a final
-- value of this accumulator together with the new list.' (see Hoogle)

-- mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
on mapAccumL(f, acc, xs)
    script
        on |λ|(a, x)
            tell mReturn(f) to set pair to |λ|(item 1 of a, x)
            [item 1 of pair, (item 2 of a) & item 2 of pair]
        end |λ|
    end script

    foldl(result, [acc, []], xs)
end mapAccumL

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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- reverse :: [a] -> [a]
on |reverse|(xs)
    if class of xs is text then
        (reverse of characters of xs) as text
    else
        reverse of xs
    end if
end |reverse|

-- tailMay :: [a] -> Maybe [a]
on tailMay(xs)
    if length of xs > 1 then
        {nothing:false, just:items 2 thru -1 of xs}
    else
        {nothing:true}
    end if
end tailMay

-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set mp to mReturn(p)
    set v to x

    tell mReturn(f)
        repeat until mp's |λ|(v)
            set v to |λ|(v)
        end repeat
    end tell
    return v
end |until|
