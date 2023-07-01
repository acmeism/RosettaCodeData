use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

on run
    unlines(map(¬
        compose(compose(unlines, sparkLine), readFloats), ¬
        {"0, 1, 19, 20", "0, 999, 4000, 4999, 7000, 7999", ¬
            "0, 1000, 4000, 5000, 7000, 8000", ¬
            "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1", ¬
            "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5"}))
end run


-- sparkLine :: [Float] -> [String]
on sparkLine(xs)
    set ys to sort(xs)
    set mn to item 1 of ys
    set mx to item -1 of ys
    set n to length of xs
    set mid to (n div 2)
    set w to (mx - mn) / 8

    script bound
        on |λ|(x)
            mn + (w * x)
        end |λ|
    end script
    set lbounds to map(bound, enumFromTo(1, 7))

    script spark
        on |λ|(x)
            script flipGT
                on |λ|(b)
                    b > x
                end |λ|
            end script
            script indexedBlock
                on |λ|(i)
                    item i of "▁▂▃▄▅▆▇"
                end |λ|
            end script
            maybe("█", indexedBlock, findIndex(flipGT, lbounds))
        end |λ|
    end script

    script str
        on |λ|(x)
            x as string
        end |λ|
    end script

    {concat(map(spark, xs)), ¬
        unwords(map(str, xs)), ¬
        "Min " & mn as string, ¬
        "Mean " & roundTo(mean(xs), 2) as string, ¬
        "Median " & bool(item mid of xs, ((item mid of xs) + ¬
        (item (mid + 1) of xs)) / 2, even(n)), ¬
        "Max " & mx as string, ""}
end sparkLine


-- GENERIC -------------------------------------------------

-- Just :: a -> Maybe a
on Just(x)
    {type:"Maybe", Nothing:false, Just:x}
end Just

-- Nothing :: Maybe a
on Nothing()
    {type:"Maybe", Nothing:true}
end Nothing

-- bool :: a -> a -> Bool -> a
on bool(f, t, p)
    if p then
        t
    else
        f
    end if
end bool

-- compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
on compose(f, g)
    script
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            mf's |λ|(mg's |λ|(x))
        end |λ|
    end script
end compose

-- concat :: [[a]] -> [a]
-- concat :: [String] -> String
on concat(xs)
    set lng to length of xs
    if 0 < lng and string is class of (item 1 of xs) then
        set acc to ""
    else
        set acc to {}
    end if
    repeat with i from 1 to lng
        set acc to acc & item i of xs
    end repeat
    acc
end concat

-- enumFromTo :: Int -> Int -> [Int]
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

-- even :: Int -> Bool
on even(x)
    0 = x mod 2
end even

-- Takes a predicate function and a list and
-- returns Just( the 1-based index of the first
-- element ) in the list satisfying the predicate
-- or Nothing if there is no such element.
-- findIndex(isSpace, "hello world")
--> {type:"Maybe", Nothing:false, Just:6}

-- findIndex(even, [3, 5, 7, 8, 9])
--> {type:"Maybe", Nothing:false, Just:4}

-- findIndex(isUpper, "all lower case")
--> {type:"Maybe", Nothing:true}
-- findIndex :: (a -> Bool) -> [a] -> Maybe Int
on findIndex(p, xs)
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then return Just(i)
        end repeat
        return Nothing()
    end tell
end findIndex

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

-- mean :: [Num] -> Num
on mean(xs)
    script
        on |λ|(a, x)
            a + x
        end |λ|
    end script
    foldl(result, 0, xs) / (length of xs)
end mean

-- | The 'maybe' function takes a default value, a function, and a 'Maybe'
-- value.  If the 'Maybe' value is 'Nothing', the function returns the
-- default value.  Otherwise, it applies the function to the value inside
-- the 'Just' and returns the result.
-- maybe :: b -> (a -> b) -> Maybe a -> b
on maybe(v, f, mb)
    if Nothing of mb then
        v
    else
        tell mReturn(f) to |λ|(Just of mb)
    end if
end maybe

-- Lift 2nd class handler function into 1s class script wrapper
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

-- readFloats :: String -> [Float]
on readFloats(s)
    script asReal
        on |λ|(n)
            n as real
        end |λ|
    end script
    map(asReal, splitRegex("[\\s,]+", s))
end readFloats

-- regexMatches :: String -> String -> [[String]]
on regexMatches(strRegex, strHay)
    set ca to current application
    -- NSNotFound handling and and High Sierra workaround due to @sl1974
    set NSNotFound to a reference to 9.22337203685477E+18 + 5807
    set oRgx to ca's NSRegularExpression's regularExpressionWithPattern:strRegex ¬
        options:((ca's NSRegularExpressionAnchorsMatchLines as integer)) ¬
        |error|:(missing value)
    set oString to ca's NSString's stringWithString:strHay

    script matchString
        on |λ|(m)
            script rangeMatched
                on |λ|(i)
                    tell (m's rangeAtIndex:i)
                        set intFrom to its location
                        if NSNotFound ≠ intFrom then
                            text (intFrom + 1) thru (intFrom + (its |length|)) of strHay
                        else
                            missing value
                        end if
                    end tell
                end |λ|
            end script
        end |λ|
    end script

    script asRange
        on |λ|(x)
            range() of x
        end |λ|
    end script
    map(asRange, (oRgx's matchesInString:oString ¬
        options:0 range:{location:0, |length|:oString's |length|()}) as list)
end regexMatches


-- roundTo :: Float -> Int -> Float
on roundTo(x, n)
    set d to 10 ^ n
    (round (x * d)) / d
end roundTo

-- sort :: Ord a => [a] -> [a]
on sort(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort

-- splitRegex :: Regex -> String -> [String]
on splitRegex(strRegex, str)
    set lstMatches to regexMatches(strRegex, str)
    if length of lstMatches > 0 then
        script preceding
            on |λ|(a, x)
                set iFrom to start of a
                set iLocn to (location of x)

                if iLocn > iFrom then
                    set strPart to text (iFrom + 1) thru iLocn of str
                else
                    set strPart to ""
                end if
                {parts:parts of a & strPart, start:iLocn + (length of x) - 1}
            end |λ|
        end script

        set recLast to foldl(preceding, {parts:[], start:0}, lstMatches)

        set iFinal to start of recLast
        if iFinal < length of str then
            parts of recLast & text (iFinal + 1) thru -1 of str
        else
            parts of recLast & ""
        end if
    else
        {str}
    end if
end splitRegex

-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines

-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords
