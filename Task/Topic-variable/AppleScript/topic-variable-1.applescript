on run
    1 + 2

    ap({square, squareRoot}, {result})

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

-- A list of functions applied to a list of arguments
-- (<*> | ap) :: [(a -> b)] -> [a] -> [b]
on ap(fs, xs)
    set intFs to length of fs
    set intXs to length of xs
    set lst to {}
    repeat with i from 1 to intFs
        tell mReturn(item i of fs)
            repeat with j from 1 to intXs
                set end of lst to |λ|(contents of (item j of xs))
            end repeat
        end tell
    end repeat
    return lst
end ap

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
