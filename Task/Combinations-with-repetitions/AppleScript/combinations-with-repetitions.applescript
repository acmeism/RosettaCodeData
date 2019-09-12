-- combsWithRep :: Int -> [a] -> [kTuple a]
on combsWithRep(k, xs)
    -- A list of lists, representing
    -- sets of cardinality k, with
    -- members drawn from xs.

    script combsBySize
        script f
            on |λ|(a, x)
                script prefix
                    on |λ|(z)
                        {x} & z
                    end |λ|
                end script

                script go
                    on |λ|(ys, xs)
                        xs & map(prefix, ys)
                    end |λ|
                end script
                scanl1(go, a)
            end |λ|
        end script

        on |λ|(xs)
            foldl(f, {{{}}} & take(k, |repeat|({})), xs)
        end |λ|
    end script

    |Just| of |index|(|λ|(xs) of combsBySize, 1 + k)
end combsWithRep


-- TEST ---------------------------------------------------
on run
    {length of combsWithRep(3, enumFromTo(0, 9)), ¬
        combsWithRep(2, {"iced", "jam", "plain"})}
end run


-- GENERIC ------------------------------------------------

-- Just :: a -> Maybe a
on Just(x)
    {type:"Maybe", Nothing:false, Just:x}
end Just

-- Nothing :: Maybe a
on Nothing()
    {type:"Maybe", Nothing:true}
end Nothing

-- enumFromTo :: (Int, Int) -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        return lst
    else
        return {}
    end if
end enumFromTo

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

-- index (!!) :: [a] -> Int -> Maybe a
-- index (!!) :: Gen [a] -> Int -> Maybe a
-- index (!!) :: String -> Int -> Maybe Char
on |index|(xs, i)
    if script is class of xs then
        repeat with j from 1 to i
            set v to |λ|() of xs
        end repeat
        if missing value is not v then
            Just(v)
        else
            Nothing()
        end if
    else
        if length of xs < i then
            Nothing()
        else
            Just(item i of xs)
        end if
    end if
end |index|

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
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

-- repeat :: a -> Generator [a]
on |repeat|(x)
    script
        on |λ|()
            return x
        end |λ|
    end script
end |repeat|


-- scanl :: (b -> a -> b) -> b -> [a] -> [b]
on scanl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        set lst to {startValue}
        repeat with i from 1 to lng
            set v to |λ|(v, item i of xs, i, xs)
            set end of lst to v
        end repeat
        return lst
    end tell
end scanl

-- scanl1 :: (a -> a -> a) -> [a] -> [a]
on scanl1(f, xs)
    if 0 < length of xs then
        scanl(f, item 1 of xs, rest of xs)
    else
        {}
    end if
end scanl1


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
