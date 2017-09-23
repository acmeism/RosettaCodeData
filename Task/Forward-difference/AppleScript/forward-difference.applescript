-- FORWARD DIFFERENCE --------------------------------------------------------

-- forwardDifference :: Int -> [Int] -> [Int]
on forwardDifference(n, xs)
    set lng to length of xs

    -- atLength :: [Int] -> Bool
    script atLength
        property fullLength : lng
        property ndx : n

        on |λ|(ds)
            (atLength's fullLength) - (length of ds) ≥ atLength's ndx
        end |λ|
    end script

    -- fd :: [Int] -> [Int]
    script fd
        on |λ|(xs)
            script minus
                on |λ|(a, b)
                    a - b
                end |λ|
            end script

            zipWith(minus, tail(xs), xs)
        end |λ|
    end script

    |until|(atLength, fd, xs)
end forwardDifference


-- TEST ----------------------------------------------------------------------
on run
    set xs to {90, 47, 58, 29, 22, 32, 55, 5, 55, 73}

    script test
        on |λ|(n)
            intercalate("  ->  [", ¬
                {{n}} & intercalate(", ", forwardDifference(n, xs))) & "]"
        end |λ|
    end script

    intercalate(linefeed, map(test, enumFromTo(1, 9)))
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

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

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail

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
