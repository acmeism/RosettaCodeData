-- CARTESIAN PRODUCTS ---------------------------------------------------------

-- Two lists:

-- cartProd :: [a] -> [b] -> [(a, b)]
on cartProd(xs, ys)
    script
        on |λ|(x)
            script
                on |λ|(y)
                    [[x, y]]
                end |λ|
            end script
            concatMap(result, ys)
        end |λ|
    end script
    concatMap(result, xs)
end cartProd

-- N-ary – a function over a list of lists:

-- cartProdNary :: [[a]] -> [[a]]
on cartProdNary(xss)
    script
        on |λ|(accs, xs)
            script
                on |λ|(x)
                    script
                        on |λ|(a)
                            {x & a}
                        end |λ|
                    end script
                    concatMap(result, accs)
                end |λ|
            end script
            concatMap(result, xs)
        end |λ|
    end script
    foldr(result, {{}}, xss)
end cartProdNary

-- TESTS ----------------------------------------------------------------------
on run
    set baseExamples to unlines(map(show, ¬
        [cartProd({1, 2}, {3, 4}), ¬
            cartProd({3, 4}, {1, 2}), ¬
            cartProd({1, 2}, {}), ¬
            cartProd({}, {1, 2})]))

    set naryA to unlines(map(show, ¬
        cartProdNary([{1776, 1789}, {7, 12}, {4, 14, 23}, {0, 1}])))

    set naryB to show(cartProdNary([{1, 2, 3}, {30}, {500, 100}]))

    set naryC to show(cartProdNary([{1, 2, 3}, {}, {500, 100}]))

    intercalate(linefeed & linefeed, {baseExamples, naryA, naryB, naryC})
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lst to {}
    set lng to length of xs
    tell mReturn(f)
        repeat with i from 1 to lng
            set lst to (lst & |λ|(item i of xs, i, xs))
        end repeat
    end tell
    return lst
end concatMap

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
