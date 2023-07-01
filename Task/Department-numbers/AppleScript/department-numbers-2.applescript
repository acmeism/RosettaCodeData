-- NUMBERING CONSTRAINTS ------------------------------------------------------

-- options :: Int -> Int -> Int -> [(Int, Int, Int)]
on options(lo, hi, total)
    set ds to enumFromTo(lo, hi)

    script Xeven
        on |λ|(x)
            script Ydistinct
                on |λ|(y)
                    script ZinRange
                        on |λ|(z)
                            if y ≠ z and lo ≤ z and z ≤ hi then
                                {{x, y, z}}
                            else
                                {}
                            end if
                        end |λ|
                    end script

                    concatMap(ZinRange, {total - (x + y)}) -- Z IS IN RANGE
                end |λ|
            end script

            script notX
                on |λ|(d)
                    d ≠ x
                end |λ|
            end script

            concatMap(Ydistinct, filter(notX, ds)) -- Y IS NOT X
        end |λ|
    end script

    concatMap(Xeven, filter(my even, ds)) -- X IS EVEN
end options


-- TEST -----------------------------------------------------------------------
on run
    set xs to options(1, 7, 12)

    intercalate("\n\n", ¬
        {"(Police, Sanitation, Fire)", ¬
            unlines(map(show, xs)), ¬
            "Number of options: " & |length|(xs)})
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lst to {}
    set lng to length of xs
    tell mReturn(f)
        repeat with i from 1 to lng
            set lst to (lst & |λ|(contents of item i of xs, i, xs))
        end repeat
    end tell
    return lst
end concatMap

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
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
end enumFromTo

-- even :: Int -> Bool
on even(x)
    x mod 2 = 0
end even

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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- length :: [a] -> Int
on |length|(xs)
    length of xs
end |length|

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

-- show :: a -> String
on show(e)
    set c to class of e
    if c = list then
        script serialized
            on |λ|(v)
                show(v)
            end |λ|
        end script

        "[" & intercalate(", ", map(serialized, e)) & "]"
    else if c = record then
        script showField
            on |λ|(kv)
                set {k, ev} to kv
                "\"" & k & "\":" & show(ev)
            end |λ|
        end script

        "{" & intercalate(", ", ¬
            map(showField, zip(allKeys(e), allValues(e)))) & "}"
    else if c = date then
        "\"" & iso8601Z(e) & "\""
    else if c = text then
        "\"" & e & "\""
    else if (c = integer or c = real) then
        e as text
    else if c = class then
        "null"
    else
        try
            e as text
        on error
            ("«" & c as text) & "»"
        end try
    end if
end show

-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines
