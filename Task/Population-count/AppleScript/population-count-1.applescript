--------------------- POPULATION COUNT ---------------------

-- populationCount :: Int -> Int
on populationCount(n)
    -- The number of non-zero bits in the binary
    -- representation of the integer n.

    script go
        on |λ|(x)
            if 0 < x then
                Just({x mod 2, x div 2})
            else
                Nothing()
            end if
        end |λ|
    end script

    integerSum(unfoldr(go, n))
end populationCount


--------------------------- TEST ---------------------------
on run
    set {evens, odds} to partition(compose(even, populationCount), ¬
        enumFromTo(0, 59))

    unlines({"Population counts of the first 30 powers of three:", ¬
        tab & showList(map(compose(populationCount, raise(3)), ¬
        enumFromTo(0, 29))), ¬
        "", ¬
        "First thirty 'evil' numbers:", ¬
        tab & showList(evens), ¬
        "", ¬
        "First thirty 'odious' numbers:", ¬
        tab & showList(odds)})
end run


------------------------- GENERIC --------------------------

-- Just :: a -> Maybe a
on Just(x)
    -- Constructor for an inhabited Maybe (option type) value.
    -- Wrapper containing the result of a computation.
    {type:"Maybe", Nothing:false, Just:x}
end Just


-- Nothing :: Maybe a
on Nothing()
    -- Constructor for an empty Maybe (option type) value.
    -- Empty wrapper returned where a computation is not possible.
    {type:"Maybe", Nothing:true}
end Nothing


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


-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        lst
    else
        {}
    end if
end enumFromTo


-- even :: Int -> Bool
on even(x)
    0 = x mod 2
end even


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
    {ys, zs}
end partition

-- raise :: Num -> Int -> Num
on raise(m)
    script
        on |λ|(n)
            m ^ n
        end |λ|
    end script
end raise


-- integerSum :: [Num] -> Num
on integerSum(xs)
    script addInt
        on |λ|(a, b)
            a + (b as integer)
        end |λ|
    end script

    foldl(addInt, 0, xs)
end integerSum


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


-- showList :: [a] -> String
on showList(xs)
    "[" & intercalate(",", map(my str, xs)) & "]"
end showList


-- str :: a -> String
on str(x)
    x as string
end str


-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    -- A list derived from a simple value.
    -- Dual to foldr.
    -- unfoldr (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
    -- -> [10,9,8,7,6,5,4,3,2,1]
    set xr to {v, v} -- (value, remainder)
    set xs to {}
    tell mReturn(f)
        repeat -- Function applied to remainder.
            set mb to |λ|(item 2 of xr)
            if Nothing of mb then
                exit repeat
            else -- New (value, remainder) tuple,
                set xr to Just of mb
                -- and value appended to output list.
                set end of xs to item 1 of xr
            end if
        end repeat
    end tell
    return xs
end unfoldr


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
