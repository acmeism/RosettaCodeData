-- zeckendorf :: Int -> String
on zeckendorf(n)
    script f
        on lambda(n, x)
            if n < x then
                [n, 0]
            else
                [n - x, 1]
            end if
        end lambda
    end script

    if n = 0 then
        {0} as string
    else
        item 2 of mapAccumL(f, n, _reverse(tail(fibUntil(n)))) as string
    end if
end zeckendorf


-- fibUntil :: Int -> [Int]
on fibUntil(n)
    set xs to {}
    set limit to n

    script atLimit
        property ceiling : limit
        on lambda(x)
            (item 2 of x) > (atLimit's ceiling)
        end lambda
    end script

    script nextPair
        property series : xs
        on lambda([a, b])
            set nextPair's series to nextPair's series & b
            [b, a + b]
        end lambda
    end script

    |until|(atLimit, nextPair, {0, 1})
    return nextPair's series
end fibUntil


-- TEST
on run

    intercalate(linefeed, ¬
        map(zeckendorf, range(0, 20)))

end run


-- GENERIC LIBRARY FUNCTIONS

-- 'The mapAccumL function behaves like a combination of map and foldl;
-- it applies a function to each element of a list, passing an
-- accumulating parameter from left to right, and returning a final
-- value of this accumulator together with the new list.' (see Hoogle)

-- mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
on mapAccumL(f, acc, xs)
    script
        on lambda(a, x)
            tell mReturn(f) to set pair to lambda(item 1 of a, x)
            [item 1 of pair, (item 2 of a) & item 2 of pair]
        end lambda
    end script

    foldl(result, [acc, []], xs)
end mapAccumL

-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set mp to mReturn(p)
    set mf to mReturn(f)

    script
        property p : mp's lambda
        property f : mf's lambda

        on lambda(v)
            repeat until p(v)
                set v to f(v)
            end repeat
            return v
        end lambda
    end script

    result's lambda(x)
end |until|

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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- _reverse :: [a] -> [a]
on _reverse(xs)
    if class of xs is text then
        (reverse of characters of xs) as text
    else
        reverse of xs
    end if
end _reverse

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail
