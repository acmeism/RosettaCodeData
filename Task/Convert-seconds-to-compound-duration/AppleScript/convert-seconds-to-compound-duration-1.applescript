-------------------- COMPOUND DURATIONS ------------------

-- weekParts Int -> [Int]
on weekParts(intSeconds)
    unitParts(intSeconds, [missing value, 7, 24, 60, 60])
end weekParts


-- localCompoundDuration :: Int -> String
on localCompoundDuration(localNames, intSeconds)

    -- [String] -> (Int, String) -> [String]
    script formatted
        on |λ|(lstPair, a)
            set q to item 1 of lstPair
            if q > 0 then
                {(q as string) & space & item 2 of lstPair} & a
            else
                a
            end if
        end |λ|
    end script

    intercalate(", ", ¬
        foldr(formatted, [], ¬
            zip(weekParts(intSeconds), localNames)))
end localCompoundDuration

------------------ INTEGER DECOMPOSITION -----------------

-- unitParts :: Int -> [maybe Int] -> [Int]
on unitParts(intTotal, unitList)
    -- partList :: Record -> Int -> Record
    script partList
        on |λ|(x, a)
            set intRest to remaining of a

            if x is not missing value then
                set intMod to intRest mod x
                set d to x
            else
                set intMod to intRest
                set d to 1
            end if

            {remaining:(intRest - intMod) div d, parts:{intMod} & parts of a}
        end |λ|
    end script

    parts of foldr(partList, ¬
        {remaining:intTotal, parts:[]}, unitList)
end unitParts

--------------------------- TEST -------------------------
on run
    script angloNames
        on |λ|(n)
            (n as string) & "     ->    " & ¬
                localCompoundDuration(["wk", "d", "hr", "min", "sec"], n)
        end |λ|
    end script

    unlines(map(angloNames, [7259, 86400, 6000000]))
end run


-------------------- GENERIC FUNCTIONS -------------------

-- foldr :: (a -> b -> b) -> b -> [a] -> b
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(item i of xs, v, i, xs)
        end repeat
        return v
    end tell
end foldr


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
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


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set s to xs as text
    set my text item delimiters to dlm
    s
end unlines


-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    -- A list of step-wise pairs drawn from xs and ys
    -- up to the length of the shorter of those lists.
    set lng to min(length of xs, length of ys)
    set zs to {}
    repeat with i from 1 to lng
        set end of zs to {item i of xs, item i of ys}
    end repeat
    return zs
end zip
