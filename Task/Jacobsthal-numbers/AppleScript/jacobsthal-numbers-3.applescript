-------------------- JACOBSTHAL NUMBERS ------------------

-- e.g. take(10, jacobsthal())

-- jacobsthal :: [Int]
on jacobsthal()
    -- The terms of OEIS:A001045 as a non-finite sequence.
    jacobsthalish(0, 1)
end jacobsthal


-- jacobsthal :: (Int, Int) -> [Int]
on jacobsthalish(x, y)
    -- An infinite sequence of the terms of the
    -- Jacobsthal-type series which begins with x and y.
    script go
        on |λ|(ab)
            set {a, b} to ab

            {a, {b, (2 * a) + b}}
        end |λ|
    end script

    unfoldr(go, {x, y})
end jacobsthalish


-------------------------- TESTS -------------------------
on run
    unlines(map(fShow, {¬
        {"terms of the Jacobsthal sequence", ¬
            30, jacobsthal()}, ¬
        {"Jacobsthal-Lucas numbers", ¬
            30, jacobsthalish(2, 1)}, ¬
        {"Jacobsthal oblong numbers", ¬
            20, zipWith(my mul, jacobsthal(), drop(1, jacobsthal()))}, ¬
        {"primes in the Jacobsthal sequence", ¬
            10, filter(isPrime, jacobsthal())}}))
end run


------------------------ FORMATTING ----------------------
on fShow(test)
    set {k, n, xs} to test

    str(n) & " first " & k & ":" & linefeed & ¬
        table(5, map(my str, take(n, xs))) & linefeed
end fShow


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller)
    script go
        on |λ|(s)
            if n > length of s then
                text -n thru -1 of ((replicate(n, cFiller) as text) & s)
            else
                s
            end if
        end |λ|
    end script
end justifyRight


-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> String -> String
on replicate(n, s)
    -- Egyptian multiplication - progressively doubling a list,
    -- appending stages of doubling to an accumulator where needed
    -- for binary assembly of a target length
    script p
        on |λ|({n})
            n ≤ 1
        end |λ|
    end script

    script f
        on |λ|({n, dbl, out})
            if (n mod 2) > 0 then
                set d to out & dbl
            else
                set d to out
            end if
            {n div 2, dbl & dbl, d}
        end |λ|
    end script

    set xs to |until|(p, f, {n, s, ""})
    item 2 of xs & item 3 of xs
end replicate


-- table :: Int -> [String] -> String
on table(n, xs)
    -- A list of strings formatted as
    -- right-justified rows of n columns.
    set w to length of last item of xs
    unlines(map(my unwords, ¬
        chunksOf(n, map(justifyRight(w, space), xs))))
end table


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


-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set v to x
    set mp to mReturn(p)
    set mf to mReturn(f)
    repeat until mp's |λ|(v)
        set v to mf's |λ|(v)
    end repeat
    v
end |until|


-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords


------------------------- GENERIC ------------------------

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


-- abs :: Num -> Num
on abs(x)
    -- Absolute value.
    if 0 > x then
        -x
    else
        x
    end if
end abs


-- any :: (a -> Bool) -> [a] -> Bool
on any(p, xs)
    -- Applied to a predicate and a list,
    -- |any| returns true if at least one element of the
    -- list satisfies the predicate.
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then return true
        end repeat
        false
    end tell
end any


-- chunksOf :: Int -> [a] -> [[a]]
on chunksOf(k, xs)
    script
        on go(ys)
            set ab to splitAt(k, ys)
            set a to item 1 of ab
            if {} ≠ a then
                {a} & go(item 2 of ab)
            else
                a
            end if
        end go
    end script
    result's go(xs)
end chunksOf


-- drop :: Int -> [a] -> [a]
-- drop :: Int -> String -> String
on drop(n, xs)
    take(n, xs) -- consumed
    xs
end drop


-- enumFromThenTo :: Int -> Int -> Int -> [Int]
on enumFromThenTo(x1, x2, y)
    set xs to {}
    set gap to x2 - x1
    set d to max(1, abs(gap)) * (signum(gap))
    repeat with i from x1 to y by d
        set end of xs to i
    end repeat
    return xs
end enumFromThenTo


-- filter :: (a -> Bool) -> Gen [a] -> Gen [a]
on filter(p, gen)
    -- Non-finite stream of values which are
    -- drawn from gen, and satisfy p
    script
        property mp : mReturn(p)'s |λ|
        on |λ|()
            set v to gen's |λ|()
            repeat until mp(v)
                set v to gen's |λ|()
            end repeat
            return v
        end |λ|
    end script
end filter


-- isPrime :: Int -> Bool
on isPrime(n)
    -- True if n is prime

    if {2, 3} contains n then return true

    if 2 > n or 0 = (n mod 2) then return false

    if 9 > n then return true

    if 0 = (n mod 3) then return false

    script p
        on |λ|(x)
            0 = n mod x or 0 = n mod (2 + x)
        end |λ|
    end script

    not any(p, enumFromThenTo(5, 11, 1 + (n ^ 0.5)))
end isPrime


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


-- max :: Ord a => a -> a -> a
on max(x, y)
    if x > y then
        x
    else
        y
    end if
end max


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


-- mul (*) :: Num a => a -> a -> a
on mul(a, b)
    a * b
end mul


-- signum :: Num -> Num
on signum(x)
    if x < 0 then
        -1
    else if x = 0 then
        0
    else
        1
    end if
end signum


-- splitAt :: Int -> [a] -> ([a], [a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            {items 1 thru n of xs as text, ¬
                items (n + 1) thru -1 of xs as text}
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


-- str :: a -> String
on str(x)
    x as string
end str


-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
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


-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    set lng to |length|(xs)
    if 0 = lng then
        Nothing()
    else
        if (2 ^ 29 - 1) as integer > lng then
            if class of xs is string then
                set cs to text items of xs
                Just({item 1 of cs, rest of cs})
            else
                Just({item 1 of xs, rest of xs})
            end if
        else
            set nxt to take(1, xs)
            if {} is nxt then
                Nothing()
            else
                Just({item 1 of nxt, xs})
            end if
        end if
    end if
end uncons


-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    -- A lazy (generator) list unfolded from a seed value
    -- by repeated application of f to a value until no
    -- residue remains. Dual to fold/reduce.
    -- f returns either nothing (missing value)
    -- or just (value, residue).
    script
        property valueResidue : {v, v}
        property g : mReturn(f)
        on |λ|()
            set valueResidue to g's |λ|(item 2 of (valueResidue))
            if missing value ≠ valueResidue then
                item 1 of (valueResidue)
            else
                missing value
            end if
        end |λ|
    end script
end unfoldr


-- zipWith :: (a -> b -> c) -> Gen [a] -> Gen [b] -> Gen [c]
on zipWith(f, ga, gb)
    script
        property ma : missing value
        property mb : missing value
        property mf : mReturn(f)
        on |λ|()
            if missing value is ma then
                set ma to uncons(ga)
                set mb to uncons(gb)
            end if
            if Nothing of ma or Nothing of mb then
                missing value
            else
                set ta to Just of ma
                set tb to Just of mb
                set ma to uncons(item 2 of ta)
                set mb to uncons(item 2 of tb)
                |λ|(item 1 of ta, item 1 of tb) of mf
            end if
        end |λ|
    end script
end zipWith
