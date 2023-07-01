--------------------- ROOT MEAN SQUARE -------------------

-- rootMeanSquare :: [Num] -> Real
on rootMeanSquare(xs)
    script
        on |λ|(a, x)
            a + x * x
        end |λ|
    end script

    (foldl(result, 0, xs) / (length of xs)) ^ (1 / 2)
end rootMeanSquare


--------------------------- TEST -------------------------
on run

    rootMeanSquare({1, 2, 3, 4, 5, 6, 7, 8, 9, 10})

    -- > 6.204836822995
end run


-------------------- GENERIC FUNCTIONS -------------------

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

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn
