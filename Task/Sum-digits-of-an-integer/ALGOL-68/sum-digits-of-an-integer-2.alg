----------------- SUM DIGITS OF AN INTEGER -----------------

-- baseDigitSum :: Int -> Int -> Int
on baseDigitSum(base)
    script
        on |λ|(n)
            script go
                on |λ|(x)
                    if 0 < x then
                        Just({x mod base, x div base})
                    else
                        Nothing()
                    end if
                end |λ|
            end script
            sum(unfoldl(go, n))
        end |λ|
    end script
end baseDigitSum


--------------------------- TEST ---------------------------
on run
    {ap(map(baseDigitSum, {2, 8, 10, 16}), {255}), ¬
        ap(map(baseDigitSum, {10}), {1, 1234}), ¬
        ap(map(baseDigitSum, {16}), map(readHex, {"0xfe", "0xf0e"}))}

    --> {{8, 17, 12, 30}, {1, 10}, {29, 29}}
end run


-------------------- GENERIC FUNCTIONS ---------------------

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


-- Each member of a list of functions applied to
-- each of a list of arguments, deriving a list of new values
-- ap (<*>) :: [(a -> b)] -> [a] -> [b]
on ap(fs, xs)
    set lst to {}
    repeat with f in fs
        tell mReturn(contents of f)
            repeat with x in xs
                set end of lst to |λ|(contents of x)
            end repeat
        end tell
    end repeat
    return lst
end ap


-- elemIndex :: Eq a => a -> [a] -> Maybe Int
on elemIndex(x, xs)
    set lng to length of xs
    repeat with i from 1 to lng
        if x = (item i of xs) then return Just(i - 1)
    end repeat
    return Nothing()
end elemIndex


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


-- identity :: a -> a
on identity(x)
    -- The argument unchanged.
    x
end identity


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


-- maybe :: b -> (a -> b) -> Maybe a -> b
on maybe(v, f, mb)
    -- Either the default value v (if mb is Nothing),
    -- or the application of the function f to the
    -- contents of the Just value in mb.
    if Nothing of mb then
        v
    else
        tell mReturn(f) to |λ|(Just of mb)
    end if
end maybe


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


-- readHex :: String -> Int
on readHex(s)
    -- The integer value of the given hexadecimal string.
    set ds to "0123456789ABCDEF"
    script go
        on |λ|(c, a)
            set {v, e} to a
            set i to maybe(0, my identity, elemIndex(c, ds))
            {v + (i * e), 16 * e}
        end |λ|
    end script
    item 1 of foldr(go, {0, 1}, characters of s)
end readHex


-- sum :: [Num] -> Num
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(add, 0, xs)
end sum


-- > unfoldl (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
-- > [1,2,3,4,5,6,7,8,9,10]
-- unfoldl :: (b -> Maybe (b, a)) -> b -> [a]
on unfoldl(f, v)
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
                set xs to ({item 1 of xr} & xs)
            end if
        end repeat
    end tell
    return xs
end unfoldl
