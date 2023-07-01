-- thueMorse :: Int -> [Int]
on thueMorse(base)
    -- Non-finite sequence of Thue-Morse terms for a given base.
    fmapGen(baseDigitsSumModBase(base), enumFrom(0))
end thueMorse


-- baseDigitsSumModBase :: Int -> Int -> Int
on baseDigitsSumModBase(b)
    script
        on |λ|(n)
            script go
                on |λ|(x)
                    if 0 < x then
                        Just(Tuple(x mod b, x div b))
                    else
                        Nothing()
                    end if
                end |λ|
            end script
            sum(unfoldl(go, n)) mod b
        end |λ|
    end script
end baseDigitsSumModBase


-------------------------- TEST ---------------------------
on run
    script rjust
        on |λ|(x)
            justifyRight(2, space, str(x))
        end |λ|
    end script

    script test
        on |λ|(n)
            |λ|(n) of rjust & " -> " & ¬
                showList(map(rjust, take(25, thueMorse(n))))
        end |λ|
    end script

    unlines({"First 25 fairshare terms for N players:"} & ¬
        map(test, {2, 3, 5, 11}))
end run


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


-- enumFrom :: Enum a => a -> [a]
on enumFrom(x)
    script
        property v : missing value
        property blnNum : class of x is not text
        on |λ|()
            if missing value is not v then
                if blnNum then
                    set v to 1 + v
                else
                    set v to succ(v)
                end if
            else
                set v to x
            end if
            return v
        end |λ|
    end script
end enumFrom


-- fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
on fmapGen(f, gen)
    script
        property g : mReturn(f)
        on |λ|()
            set v to gen's |λ|()
            if v is missing value then
                v
            else
                g's |λ|(v)
            end if
        end |λ|
    end script
end fmapGen


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


-- intercalateS :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller, s)
    if n > length of s then
        text -n thru -1 of ((replicate(n, cFiller) as text) & s)
    else
        s
    end if
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


-- showList :: [a] -> String
on showList(xs)
    "[" & intercalate(",", map(my str, xs)) & "]"
end showList


-- str :: a -> String
on str(x)
    x as string
end str


-- sum :: [Num] -> Num
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(add, 0, xs)
end sum


-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    set c to class of xs
    if list is c then
        if 0 < n then
            items 1 thru min(n, length of xs) of xs
        else
            {}
        end if
    else if string is c then
        if 0 < n then
            text 1 thru min(n, length of xs) of xs
        else
            ""
        end if
    else if script is c then
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
    else
        missing value
    end if
end take


-- > unfoldl (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
-- > [1,2,3,4,5,6,7,8,9,10]
-- unfoldl :: (b -> Maybe (b, a)) -> b -> [a]
on unfoldl(f, v)
    set xr to Tuple(v, v) -- (value, remainder)
    set xs to {}
    tell mReturn(f)
        repeat -- Function applied to remainder.
            set mb to |λ|(|2| of xr)
            if Nothing of mb then
                exit repeat
            else -- New (value, remainder) tuple,
                set xr to Just of mb
                -- and value appended to output list.
                set xs to ({|1| of xr} & xs)
            end if
        end repeat
    end tell
    return xs
end unfoldl


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
