------------------------REP-CYCLES-------------------------

-- repCycles :: String -> [String]
on repCycles(xs)
    set n to length of xs

    script isCycle
        on |λ|(cs)
            xs = takeCycle(n, cs)
        end |λ|
    end script

    filter(isCycle, tail(inits(take(quot(n, 2), xs))))
end repCycles

-- cycleReport :: String -> [String]
on cycleReport(xs)
    set reps to repCycles(xs)

    if isNull(reps) then
        {xs, "(n/a)"}
    else
        {xs, item -1 of reps}
    end if
end cycleReport


---------------------------TEST----------------------------
on run
    set samples to {"1001110011", "1110111011", "0010010010", ¬
        "1010101010", "1111111111", "0100101101", "0100100", ¬
        "101", "11", "00", "1"}

    unlines(cons("Longest cycle:" & linefeed, ¬
        map(intercalate(" -> "), ¬
            map(cycleReport, samples))))

end run


---------------------GENERIC FUNCTIONS---------------------

-- concat :: [[a]] -> [a] | [String] -> String
on concat(xs)
    if length of xs > 0 and class of (item 1 of xs) is string then
        set acc to ""
    else
        set acc to {}
    end if
    repeat with i from 1 to length of xs
        set acc to acc & item i of xs
    end repeat
    acc
end concat

-- cons :: a -> [a] -> [a]
on cons(x, xs)
    {x} & xs
end cons

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

-- inits :: [a] -> [[a]]
-- inits :: String -> [String]
on inits(xs)
    script elemInit
        on |λ|(_, i, xs)
            items 1 thru i of xs
        end |λ|
    end script

    script charInit
        on |λ|(_, i, xs)
            text 1 thru i of xs
        end |λ|
    end script

    if class of xs is string then
        {""} & map(charInit, xs)
    else
        {{}} & map(elemInit, xs)
    end if
end inits

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText)
    script
        on |λ|(xs)
            set {dlm, my text item delimiters} to {my text item delimiters, strText}
            set strJoined to xs as text
            set my text item delimiters to dlm
            return strJoined
        end |λ|
    end script
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

-- isNull :: [a] -> Bool
on isNull(xs)
    xs = {}
end isNull

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

-- quot :: Integral a => a -> a -> a
on quot(n, m)
    n div m
end quot

-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if n < 1 then return out
    set dbl to {a}

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail

-- take :: Int -> [a] -> [a]
on take(n, xs)
    if class of xs is string then
        if n > 0 then
            text 1 thru min(n, length of xs) of xs
        else
            ""
        end if
    else
        if n > 0 then
            items 1 thru min(n, length of xs) of xs
        else
            {}
        end if
    end if
end take

-- takeCycle :: Int -> [a] -> [a]
on takeCycle(n, xs)
    set lng to length of xs
    if lng ≥ n then
        set cycle to xs
    else
        set cycle to concat(replicate((n div lng) + 1, xs))
    end if

    if class of xs is string then
        items 1 thru n of cycle as string
    else
        items 1 thru n of cycle
    end if
end takeCycle

-- unlines :: [String] -> String
on unlines(xs)
    |λ|(xs) of intercalate(linefeed)
end unlines
