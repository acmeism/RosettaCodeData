-- PASCAL MATRIX -------------------------------------------------------------

-- pascalMatrix :: ((Int, Int) -> (Int, Int)) -> Int -> [[Int]]
on pascalMatrix(f, n)
    chunksOf(n, map(compose(my bc, f), range({{0, 0}, {n - 1, n - 1}})))
end pascalMatrix

-- Binomial coefficient
-- bc :: (Int, Int) -> Int
on bc(nk)
    set {n, k} to nk
    script bc_
        on |λ|(a, x)
            floor((a * (n - x + 1)) / x)
        end |λ|
    end script
    foldl(bc_, 1, enumFromTo(1, k))
end bc


-- TEST ----------------------------------------------------------------------
on run
    set matrixSize to 5

    script symm
        on |λ|(ab)
            set {a, b} to ab
            {a + b, a}
        end |λ|
    end script

    script format
        on |λ|(s, xs)
            unlines(concat({{s}, map(my show, xs), {""}}))
        end |λ|
    end script

    unlines(zipWith(format, ¬
        {"Lower", "Upper", "Symmetric"}, ¬
        |<*>|(map(curry(pascalMatrix), [|id|, swap, symm]), {matrixSize})))
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- A list of functions applied to a list of arguments
-- (<*> | ap) :: [(a -> b)] -> [a] -> [b]
on |<*>|(fs, xs)
    set {nf, nx} to {length of fs, length of xs}
    set acc to {}
    repeat with i from 1 to nf
        tell mReturn(item i of fs)
            repeat with j from 1 to nx
                set end of acc to |λ|(contents of (item j of xs))
            end repeat
        end tell
    end repeat
    return acc
end |<*>|

-- chunksOf :: Int -> [a] -> [[a]]
on chunksOf(k, xs)
    script
        on go(ys)
            set {a, b} to splitAt(k, ys)
            if isNull(a) then
                {}
            else
                {a} & go(b)
            end if
        end go
    end script
    result's go(xs)
end chunksOf

-- compose :: (b -> c) -> (a -> b) -> (a -> c)
on compose(f, g)
    script
        on |λ|(x)
            mReturn(f)'s |λ|(mReturn(g)'s |λ|(x))
        end |λ|
    end script
end compose

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

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    set lst to {}
    repeat with i from m to n
        set end of lst to i
    end repeat
    return lst
end enumFromTo

-- floor :: Num -> Int
on floor(x)
    if x < 0 and x mod 1 is not 0 then
        (x div 1) - 1
    else
        (x div 1)
    end if
end floor

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

-- foldr :: (b -> a -> a) -> a -> [b] -> a
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

-- id :: a -> a
on |id|(x)
    x
end |id|

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- isNull :: [a] -> Bool
on isNull(xs)
    if class of xs is string then
        xs = ""
    else
        xs = {}
    end if
end isNull

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

-- quot :: Int -> Int -> Int
on quot(m, n)
    m div n
end quot

-- range :: Ix a => (a, a) -> [a]
on range({a, b})
    if class of a is list then
        set {xs, ys} to {a, b}
    else
        set {xs, ys} to {{a}, {b}}
    end if
    set lng to length of xs

    if lng = length of ys then
        if lng > 1 then
            script
                on |λ|(_, i)
                    enumFromTo(item i of xs, item i of ys)
                end |λ|
            end script
            sequence(map(result, xs))
        else
            enumFromTo(a, b)
        end if
    else
        {}
    end if
end range

-- sequence :: Monad m => [m a] -> m [a]
-- sequence :: [a] -> [[a]]
on sequence(xs)
    traverse(|id|, xs)
end sequence

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

-- splitAt :: Int -> [a] -> ([a],[a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            {items 1 thru n of xs as text, items (n + 1) thru -1 of xs as text}
        else
            {items 1 thru n of xs, items (n + 1) thru -1 of xs}
        end if
    else
        if n < 1 then
            {{}, xs}
        else
            {xs, {}}
        end if
    end if
end splitAt

-- swap :: (a, b) -> (b, a)
on swap(ab)
    set {a, b} to ab
    {b, a}
end swap

-- traverse :: (a -> [b]) -> [a] -> [[b]]
on traverse(f, xs)
    script
        property mf : mReturn(f)
        on |λ|(x, a)
            |<*>|(map(curry(cons), mf's |λ|(x)), a)
        end |λ|
    end script
    foldr(result, {{}}, xs)
end traverse

-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines

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
