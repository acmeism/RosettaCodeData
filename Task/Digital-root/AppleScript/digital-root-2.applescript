-------------------------- TESTS --------------------------
on run
    set firstCol to justifyRight(18, space)

    script test
        on |λ|(x)
            firstCol's |λ|(str(x)) & ¬
                " -> " & showTuple(digitalRoot(10)'s |λ|(x))
        end |λ|
    end script

    unlines({"Base 10:", firstCol's |λ|("Integer") & ¬
        " -> (additive persistance, digital root)"} & ¬
        map(test, ¬
            {627615, 39390, 588225, 3.93900588225E+11}))
end run


---------------- DIGITAL ROOTS IN ANY BASE ----------------

-- digitalRoot :: Int -> Int -> (Int, Int)
on digitalRoot(base)
    script p
        on |λ|(x)
            snd(x) ≥ base
        end |λ|
    end script

    script
        on |λ|(n)
            next(dropWhile(p, ¬
                iterate(bimap(my succ, digitalSum(base)), ¬
                    Tuple(0, n))))
        end |λ|
    end script
end digitalRoot


-- digitalSum :: Int -> Int -> Int
on digitalSum(base)
    script
        on |λ|(n)
            script go
                on |λ|(x)
                    if x > 0 then
                        Just(Tuple(x mod base, x div base))
                    else
                        Nothing()
                    end if
                end |λ|
            end script
            sum(unfoldr(go, n))
        end |λ|
    end script
end digitalSum


-------------------- GENERIC FUNCTIONS --------------------

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


-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    -- Constructor for a pair of values, possibly of two different types.
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple


-- bimap :: (a -> b) -> (c -> d) -> (a, c) -> (b, d)
on bimap(f, g)
    -- Tuple instance of bimap.
    -- A tuple of the application of f and g to the
    -- first and second values of tpl respectively.
    script
        on |λ|(x)
            Tuple(|λ|(fst(x)) of mReturn(f), ¬
                |λ|(snd(x)) of mReturn(g))
        end |λ|
    end script
end bimap


-- cons :: a -> [a] -> [a]
on cons(x, xs)
    set c to class of xs
    if list is c then
        {x} & xs
    else if script is c then
        script
            property pRead : false
            on |λ|()
                if pRead then
                    |λ|() of xs
                else
                    set pRead to true
                    return x
                end if
            end |λ|
        end script
    else
        x & xs
    end if
end cons


-- dropWhile :: (a -> Bool) -> Gen [a] -> [a]
on dropWhile(p, xs)
    set v to |λ|() of xs
    tell mReturn(p)
        repeat while (|λ|(v))
            set v to xs's |λ|()
        end repeat
    end tell
    return cons(v, xs)
end dropWhile


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


-- iterate :: (a -> a) -> a -> Gen [a]
on iterate(f, x)
    script
        property v : missing value
        property g : mReturn(f)
        on |λ|()
            if missing value is v then
                set v to x
            else
                set v to g's |λ|(v)
            end if
            return v
        end |λ|
    end script
end iterate


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller)
    script
        on |λ|(s)
            if n > length of s then
                text -n thru -1 of ((replicate(n, cFiller) as text) & s)
            else
                strText
            end if
        end |λ|
    end script
end justifyRight


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


-- next :: Gen [a] -> a
on next(xs)
    |λ|() of xs
end next


-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if 1 > n then return out
    set dbl to {a}

    repeat while (1 < n)
        if 0 < (n mod 2) then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate


-- showTuple :: Tuple -> String
on showTuple(tpl)
    "(" & str(fst(tpl)) & ", " & str(snd(tpl)) & ")"
end showTuple


-- snd :: (a, b) -> b
on snd(tpl)
    if class of tpl is record then
        |2| of tpl
    else
        item 2 of tpl
    end if
end snd


-- str :: a -> String
on str(x)
    x as string
end str


-- succ :: Enum a => a -> a
on succ(x)
    1 + x
end succ


-- sum :: [Num] -> Num
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(add, 0, xs)
end sum


-- take :: Int -> Gen [a] -> [a]
on take(n, xs)
    set ys to {}
    repeat with i from 1 to n
        set v to |λ|() of xs
        if missing value is v then
            return ys
        else
            set end of ys to v
        end if
    end repeat
    return ys
end take


-- > unfoldr (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
-- > [10,9,8,7,6,5,4,3,2,1]
-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    set xr to {v, v} -- (value, remainder)
    set xs to {}
    tell mReturn(f)
        repeat -- Function applied to remainder.
            set mb to |λ|(snd(xr))
            if Nothing of mb then
                exit repeat
            else -- New (value, remainder) tuple,
                set xr to Just of mb
                -- and value appended to output list.
                set end of xs to fst(xr)
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
