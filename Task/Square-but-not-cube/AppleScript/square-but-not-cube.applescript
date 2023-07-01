on run
    script listing
        on |λ|(x)
            set sqr to x * x
            set strSquare to sqr as text

            if isCube(sqr) then
                strSquare & " (also cube)"
            else
                strSquare
            end if
        end |λ|
    end script

    unlines(map(listing, ¬
        enumFromTo(1, 33)))
end run

-- isCube :: Int -> Bool
on isCube(x)
    x = (round (x ^ (1 / 3))) ^ 3
end isCube


-- GENERIC FUNCTIONS -------------------------------------------------

-- enumFromTo :: Int -> Int -> [Int]
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

-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines
