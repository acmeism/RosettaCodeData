-- weave :: [String] -> [String]
on weave(xs)
    script thread
        property f : zipWith(my append)
        on |λ|(x)
            f's |λ|(f's |λ|(xs, x), xs)
        end |λ|
    end script

    script blank
        on |λ|(x)
            replicate(length of x, space)
        end |λ|
    end script

    concatMap(thread, {xs, map(blank, xs), xs})
end weave



-- TEST ---------------------------------------------------
on run
    -- sierpinksi :: Int -> String
    script sierpinski
        on |λ|(n)
            unlines(item n of take(n, ¬
                iterate(weave, {character id 9608})))
        end |λ|
    end script

    sierpinski's |λ|(3)
end run


-- GENERIC ABSTRACTIONS -----------------------------------

-- Append two lists.
-- append (++) :: [a] -> [a] -> [a]
-- append (++) :: String -> String -> String
on append(xs, ys)
    xs & ys
end append

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & |λ|(item i of xs, i, xs)
        end repeat
    end tell
    return acc
end concatMap

-- iterate :: (a -> a) -> a -> Gen [a]
on iterate(f, x)
    script
        property v : missing value
        property g : mReturn(f)'s |λ|
        on |λ|()
            if missing value is v then
                set v to x
            else
                set v to g(v)
            end if
            return v
        end |λ|
    end script
end iterate


-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

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

-- replicate :: Int -> String -> String
on replicate(n, s)
    set out to ""
    if n < 1 then return out
    set dbl to s

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

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
            set v to xs's |λ|()
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

-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f)
    script
        on |λ|(xs, ys)
            set lng to min(|length|(xs), |length|(ys))
            if 1 > lng then return {}
            set xs_ to take(lng, xs) -- Allow for non-finite
            set ys_ to take(lng, ys) -- generators like cycle etc
            set lst to {}
            tell mReturn(f)
                repeat with i from 1 to lng
                    set end of lst to |λ|(item i of xs_, item i of ys_)
                end repeat
                return lst
            end tell
        end |λ|
    end script
end zipWith
