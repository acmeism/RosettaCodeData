-- isNumString :: String -> Bool
on isNumString(s)
    try
        if class of s is string then
            set c to class of (s as number)
            c is real or c is integer
        else
            false
        end if
    on error
        false
    end try
end isNumString



-- TEST
on run

    map(isNumString, {3, 3.0, 3.5, "3.5", "3E8", "-3.5", "30", "three", three, four})

    --> {false, false, false, true, true, true, true, false, false, false}

end run

-- three :: () -> Int
script three
    3
end script

-- four :: () -> Int
on four()
    4
end four


-- GENERIC FUNCTIONS FOR TEST

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to lambda(item i of xs, i, xs)
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
            property lambda : f
        end script
    end if
end mReturn
