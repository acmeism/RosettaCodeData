------------ KRONECKER PRODUCT OF TWO MATRICES -------------

-- kprod :: [[Num]] -> [[Num]] -> [[Num]]
on kprod(xs, ys)
    script concatTranspose
        on |λ|(m)
            map(my concat, my transpose(m))
        end |λ|
    end script

    script
        -- Multiplication by N over a list of lists
        -- f :: [[Num]] -> Num -> [[Num]]
        on f(mx, n)
            script go
                on product(a, b)
                    a * b
                end product

                on |λ|(xs)
                    map(curry(product)'s |λ|(n), xs)
                end |λ|
            end script

            map(go, mx)
        end f

        on |λ|(zs)
            map(curry(f)'s |λ|(ys), zs)
        end |λ|
    end script

    concatMap(concatTranspose, map(result, xs))
end kprod

--------------------------- TEST ---------------------------
on run
    unlines(map(show, ¬
        kprod({{1, 2}, {3, 4}}, ¬
            {{0, 5}, {6, 7}}))) & ¬
        linefeed & linefeed & ¬
        unlines(map(show, ¬
            kprod({{0, 1, 0}, {1, 1, 1}, {0, 1, 0}}, ¬
                {{1, 1, 1, 1}, {1, 0, 0, 1}, {1, 1, 1, 1}})))
end run


-------------------- GENERIC FUNCTIONS ---------------------

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


-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    concat(map(f, xs))
end concatMap


-- curry :: (Script|Handler) -> Script
on curry(f)
    script
        on |λ|(a)
            script
                on |λ|(b)
                    |λ|(a, b) of mReturn(f)
                end |λ|
            end script
        end |λ|
    end script
end curry


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

        "{" & intercalate(", ", map(serialized, e)) & "}"
    else if c = record then
        script showField
            on |λ|(kv)
                set {k, v} to kv
                k & ":" & show(v)
            end |λ|
        end script

        "{" & intercalate(", ", ¬
            map(showField, zip(allKeys(e), allValues(e)))) & "}"
    else if c = date then
        ("date \"" & e as text) & "\""
    else if c = text then
        "\"" & e & "\""
    else
        try
            e as text
        on error
            ("«" & c as text) & "»"
        end try
    end if
end show


-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on |λ|(_, iCol)
            script row
                on |λ|(xs)
                    item iCol of xs
                end |λ|
            end script

            map(row, xss)
        end |λ|
    end script

    map(column, item 1 of xss)
end transpose


-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines
