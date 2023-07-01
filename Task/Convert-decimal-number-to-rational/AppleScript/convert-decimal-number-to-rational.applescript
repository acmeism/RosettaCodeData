--------- RATIONAL APPROXIMATION TO DECIMAL NUMBER -------

-- approxRatio :: Real -> Real -> Ratio
on approxRatio(epsilon, n)
    if {real, integer} contains (class of epsilon) and 0 < epsilon then
        -- Given
        set e to epsilon
    else
        -- Default
        set e to 1 / 10000
    end if

    script gcde
        on |λ|(e, x, y)
            script _gcd
                on |λ|(a, b)
                    if b < e then
                        a
                    else
                        |λ|(b, a mod b)
                    end if
                end |λ|
            end script
            |λ|(abs(x), abs(y)) of _gcd
        end |λ|
    end script

    set c to |λ|(e, 1, n) of gcde
    Ratio((n div c), (1 div c))
end approxRatio


-- Ratio :: Int -> Int -> Ratio
on Ratio(n, d)
    {type:"Ratio", n:n, d:d}
end Ratio


-- showRatio :: Ratio -> String
on showRatio(r)
    (n of r as string) & "/" & (d of r as string)
end showRatio


--------------------------- TEST -------------------------
on run
    script ratioString
        -- Using a tolerance epsilon of 1/10000
        on |λ|(x)
            (x as string) & " -> " & showRatio(approxRatio(1.0E-4, x))
        end |λ|
    end script

    unlines(map(ratioString, ¬
        {0.9054054, 0.518518, 0.75}))

    -- 0.9054054 -> 67/74
    -- 0.518518 -> 14/27
    -- 0.75 -> 3/4
end run


-------------------- GENERIC FUNCTIONS -------------------

-- abs :: Num -> Num
on abs(x)
    if 0 > x then
        -x
    else
        x
    end if
end abs


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
