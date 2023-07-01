on run
    script
        -- The given function applied to the value 3
        on |λ|(f)
            mReturn(f)'s |λ|(3)
        end |λ|
    end script

    -- Here, 'result' is bound to the script above
    map(result, {square, squareRoot})

    --> {9, 1.732050807569}
end run


-- square :: Num a => a -> a
on square(x)
    x * x
end square

-- squareRoot :: Num a, Float b => a -> b
on squareRoot(x)
    x ^ 0.5
end squareRoot


-- GENERIC FUNCTIONS ----------------------------------------------------------

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
