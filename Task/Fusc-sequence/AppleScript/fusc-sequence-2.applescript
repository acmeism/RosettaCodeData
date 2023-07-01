-- fusc :: [Int]
on fusc()
    -- Terms of the Fusc sequence
    -- OEIS A2487

    script go
        on |λ|(step)
            set {isEven, n, xxs} to step
            set x to item 1 of xxs

            if isEven then
                set nxt to n + x
                {not isEven, nxt, xxs & {nxt}}
            else
                {not isEven, x, rest of xxs & {x}}
            end if
        end |λ|
    end script

    appendGen(gen({0, 1}), ¬
        fmapGen(my snd, iterate(go, {true, 1, {1}})))
end fusc

-------------------------- TEST ---------------------------
on run
    unlines({¬
        "First 61 terms:", ¬
        showList(take(61, fusc())), ¬
        "", ¬
        "First term of each decimal magnitude:", ¬
        "(Index, Term):"} & ¬
        map(showTuple, take(4, firstFuscOfEachMagnitude())))
end run


---------- FIRST FUSC OF EACH DECIMAL MAGNITUDE -----------

-- firstFuscOfEachMagnitude :: [(Int, Int)]
on firstFuscOfEachMagnitude()
    -- [(Index, Term)] list of of the first Fusc
    -- terms of each decimal magnitude.
    script
        property e : -1
        property i : 0
        on |λ|()
            set e to 1 + e
            set p to 10 ^ e
            set v to fuscTerm(i)
            repeat until p ≤ v
                set i to 1 + i
                set v to fuscTerm(i)
            end repeat
            {i, v}
        end |λ|
    end script
end firstFuscOfEachMagnitude


-- fuscTerm :: Int -> Int
on fuscTerm(n)
    -- Nth term (zero-indexed) of the Fusc series.
    script go
        on |λ|(i)
            if 0 = i then
                {1, 0}
            else
                set {x, y} to |λ|(i div 2)
                if 0 = i mod 2 then
                    {x + y, y}
                else
                    {x, x + y}
                end if
            end if
        end |λ|
    end script

    tell go
        if 1 > n then
            0
        else
            item 1 of |λ|(n - 1)
        end if
    end tell
end fuscTerm



-------------------- GENERIC FUNCTIONS --------------------

-- appendGen (++) :: Gen [a] -> Gen [a] -> Gen [a]
on appendGen(xs, ys)
    script
        property vs : xs
        on |λ|()
            set v to |λ|() of vs
            if missing value is not v then
                v
            else
                set vs to ys
                |λ|() of ys
            end if
        end |λ|
    end script
end appendGen


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


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
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


-- gen :: [a] -> Gen a
on gen(xs)
    script go
        property lng : length of xs
        property i : 0
        on |λ|()
            if i ≥ lng then
                missing value
            else
                set i to 1 + i
                item i of xs
            end if
        end |λ|
    end script
end gen


-- showList :: [a] -> String
on showList(xs)
    "[" & intercalate(", ", my map(my str, xs)) & "]"
end showList


-- showTuple :: (,) -> String
on showTuple(xs)
    "(" & intercalate(", ", my map(my str, xs)) & ")"
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
