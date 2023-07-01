-- forwardDifference :: Num a => [a] -> [a]
on forwardDifference(xs)
    zipWith(my subtract, xs, rest of xs)
end forwardDifference


-- nthForwardDifference :: Num a => Int -> [a] -> [a]
on nthForwardDifference(xs, i)
    |index|(iterate(forwardDifference, xs), 1 + i)
end nthForwardDifference


-------------------------- TEST ---------------------------
on run
    script show
        on |λ|(xs, i)
            ((i - 1) as string) & " -> " & showList(xs)
        end |λ|
    end script

    unlines(map(show, ¬
        take(10, ¬
            iterate(forwardDifference, ¬
                {90, 47, 58, 29, 22, 32, 55, 5, 55, 73}))))
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


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set str to xs as text
    set my text item delimiters to dlm
    str
end intercalate


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


-- showList :: [a] -> String
on showList(xs)
    "[" & intercalate(", ", map(my str, xs)) & "]"
end showList


-- str :: a -> String
on str(x)
    x as string
end str


-- subtract :: Num -> Num -> Num
on subtract(x, y)
    y - x
end subtract


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


-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
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
end zipWith
