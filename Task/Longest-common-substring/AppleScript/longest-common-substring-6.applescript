------------------ LONGEST COMMON SUBSTRING ----------------

-- longestCommon :: Eq a => [a] -> [a] -> [a]
on longestCommon(a, b)
    -- The longest common substring of two given strings.
    script substrings
        on |λ|(s)
            map(my concat, concatMap(my tails, rest of inits(s)))
        end |λ|
    end script

    set {xs, ys} to map(substrings, {a, b})
    maximumBy(comparing(my |length|), intersect(xs, ys))
end longestCommon



-------------------------- TEST ---------------------------
on run
    longestCommon("testing123testing", "thisisatest")
end run



-------------------- GENERIC FUNCTIONS --------------------

-- comparing :: (a -> b) -> (a -> a -> Ordering)
on comparing(f)
    script
        on |λ|(a, b)
            tell mReturn(f)
                set fa to |λ|(a)
                set fb to |λ|(b)
                if fa < fb then
                    -1
                else if fa > fb then
                    1
                else
                    0
                end if
            end tell
        end |λ|
    end script
end comparing


-- concat :: [String] -> String
on concat(xs)
    script go
        on |λ|(a, x)
            a & x
        end |λ|
    end script
    foldl(go, "", xs)
end concat


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


-- inits :: String -> [String]
on inits(xs)
    script charInit
        on |λ|(_, i, xs)
            text 1 thru i of xs
        end |λ|
    end script

    {""} & map(charInit, xs)
end inits


-- intersect :: (Eq a) => [a] -> [a] -> [a]
on intersect(xs, ys)
    if length of xs < length of ys then
        set {shorter, longer} to {xs, ys}
    else
        set {longer, shorter} to {xs, ys}
    end if
    if shorter ≠ {} then
        set lst to {}
        repeat with x in shorter
            if longer contains x then set end of lst to contents of x
        end repeat
        lst
    else
        {}
    end if
end intersect


-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|


-- maximumBy :: (a -> a -> Ordering) -> [a] -> a
on maximumBy(f, xs)
    set cmp to mReturn(f)
    script max
        on |λ|(a, b)
            if a is missing value or cmp's |λ|(a, b) < 0 then
                b
            else
                a
            end if
        end |λ|
    end script

    foldl(max, missing value, xs)
end maximumBy


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


-- tails :: String -> [String]
on tails(xs)
    set es to characters of xs
    script residue
        on |λ|(_, i)
            items i thru -1 of es
        end |λ|
    end script
    map(residue, es) & {""}
end tails
