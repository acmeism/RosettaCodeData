------------- SORTED LIST OF OBJECT IDENTIFIERS ------------

-- sortedIdentifiers :: [String] -> [String]
on sortedIdentifiers(xs)
    script listCompare
        on |λ|(x, y)
            script go
                on |λ|(a, xy)
                    if 0 ≠ a then
                        a
                    else
                        compare(|1| of xy, |2| of xy)
                    end if
                end |λ|
            end script
            foldl(go, 0, zip(x, y))
        end |λ|
    end script

    map(intercalate("."), ¬
        sortBy(listCompare, ¬
            map(compose(curry(my map)'s ¬
                |λ|(my readint), splitOn(".")), xs)))
end sortedIdentifiers


---------------------------- TEST --------------------------
on run
    unlines(sortedIdentifiers({¬
        "1.3.6.1.4.1.11.2.17.19.3.4.0.10", ¬
        "1.3.6.1.4.1.11.2.17.5.2.0.79", ¬
        "1.3.6.1.4.1.11.2.17.19.3.4.0.4", ¬
        "1.3.6.1.4.1.11150.3.4.0.1", ¬
        "1.3.6.1.4.1.11.2.17.19.3.4.0.1", ¬
        "1.3.6.1.4.1.11150.3.4.0"}))
end run


--------------------- LIBRARY FUNCTIONS --------------------

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    -- Constructor for a pair of values, possibly of two different types.
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple


-- compare :: a -> a -> Ordering
on compare(a, b)
    if a < b then
        -1
    else if a > b then
        1
    else
        0
    end if
end compare


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


-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    return acc
end concatMap


-- curry :: ((a, b) -> c) -> a -> b -> c
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


-- drop :: Int -> [a] -> [a]
-- drop :: Int -> String -> String
on drop(n, xs)
    set c to class of xs
    if script is not c then
        if string is not c then
            if n < length of xs then
                items (1 + n) thru -1 of xs
            else
                {}
            end if
        else
            if n < length of xs then
                text (1 + n) thru -1 of xs
            else
                ""
            end if
        end if
    else
        take(n, xs) -- consumed
        return xs
    end if
end drop


-- findIndices :: (a -> Bool) -> [a] -> [Int]
on findIndices(p, xs)
    -- List of zero-based indices of
    -- any matches for p in xs.
    script
        property f : mReturn(p)
        on |λ|(x, i, xs)
            if f's |λ|(x, i, xs) then
                {i - 1}
            else
                {}
            end if
        end |λ|
    end script
    concatMap(result, xs)
end findIndices


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


-- fst :: (a, b) -> a
on fst(tpl)
    if class of tpl is record then
        |1| of tpl
    else
        item 1 of tpl
    end if
end fst


-- intercalate :: String -> [String] -> String
on intercalate(delim)
    script
        on |λ|(xs)
            set {dlm, my text item delimiters} to ¬
                {my text item delimiters, delim}
            set s to xs as text
            set my text item delimiters to dlm
            s
        end |λ|
    end script
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


-- Returns a sequence-matching function for findIndices etc
-- matching :: [a] -> (a -> Int -> [a] -> Bool)
-- matching :: String -> (Char -> Int -> String -> Bool)
on matching(pat)
    if class of pat is text then
        set xs to characters of pat
    else
        set xs to pat
    end if
    set lng to length of xs
    set bln to 0 < lng
    if bln then
        set h to item 1 of xs
    else
        set h to missing value
    end if
    script
        on |λ|(x, i, src)
            (h = x) and xs = ¬
                (items i thru min(length of src, -1 + lng + i) of src)
        end |λ|
    end script
end matching


-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min


-- partition :: (a -> Bool) -> [a] -> ([a], [a])
on partition(f, xs)
    tell mReturn(f)
        set ys to {}
        set zs to {}
        repeat with x in xs
            set v to contents of x
            if |λ|(v) then
                set end of ys to v
            else
                set end of zs to v
            end if
        end repeat
    end tell
    Tuple(ys, zs)
end partition


-- readInt :: String -> Int
on readint(s)
    s as integer
end readint


-- snd :: (a, b) -> b
on snd(tpl)
    if class of tpl is record then
        |2| of tpl
    else
        item 2 of tpl
    end if
end snd


-- Enough for small scale sorts.
-- Use instead sortOn (Ord b => (a -> b) -> [a] -> [a])
-- which is equivalent to the more flexible sortBy(comparing(f), xs)
-- and uses a much faster ObjC NSArray sort method
-- sortBy :: (a -> a -> Ordering) -> [a] -> [a]
on sortBy(f, xs)
    if length of xs > 1 then
        set h to item 1 of xs
        set f to mReturn(f)
        script
            on |λ|(x)
                f's |λ|(x, h) ≤ 0
            end |λ|
        end script
        set lessMore to partition(result, rest of xs)
        sortBy(f, |1| of lessMore) & {h} & ¬
            sortBy(f, |2| of lessMore)
    else
        xs
    end if
end sortBy


-- splitOn :: [a] -> [a] -> [[a]]
-- splitOn :: String -> String -> [String]
on splitOn(pat)
    script
        on |λ|(src)
            if class of src is text then
                set {dlm, my text item delimiters} to ¬
                    {my text item delimiters, pat}
                set xs to text items of src
                set my text item delimiters to dlm
                return xs
            else
                set lng to length of pat
                script residue
                    on |λ|(a, i)
                        Tuple(fst(a) & ¬
                            {init(items snd(a) thru (i) of src)}, lng + i)
                    end |λ|
                end script
                set tpl to foldl(residue, ¬
                    Tuple({}, 1), findIndices(matching(pat), src))
                return fst(tpl) & {drop(snd(tpl) - 1, src)}
            end if
        end |λ|
    end script
end splitOn


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
    zipWith(my Tuple, xs, ys)
end zip


-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    if 1 > lng then
        return {}
    else
        tell mReturn(f)
            repeat with i from 1 to lng
                set end of lst to |λ|(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith
