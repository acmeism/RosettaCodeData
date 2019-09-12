on run

    script ratioString
        -- Using a tolerance epsilon of 1/10000
        on |λ|(x)
            showRatio(approxRatio(1.0E-4, x))
        end |λ|
    end script

    map(ratioString, ¬
        {0.9054054, 0.518518, 0.75})

    --> {"67/74", "14/27", "3/4"}
end run


-- approxRatio :: Real -> Real -> Ratio
on approxRatio(epsilon, n)
    if {real, integer} contains (class of epsilon) and 0 < epsilon then
        set e to epsilon
    else
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


-- GENERIC FUNCTIONS ---------------------------------------------

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
