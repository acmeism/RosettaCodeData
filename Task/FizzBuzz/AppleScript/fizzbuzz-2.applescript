on run

    intercalate(linefeed, ¬
        map(fizzBuzz, range(1, 100)))

end run


-- fizzBuzz :: Int -> String
on fizzBuzz(x)
    caseOf(x, [[my fizzAndBuzz, "FizzBuzz"], ¬
        [my fizz, "Fizz"], ¬
        [my buzz, "Buzz"]], ¬
        x as string)
end fizzBuzz

-- fizzAndBuzz :: Int -> Bool
on fizzAndBuzz(n)
    n mod 15 = 0
end fizzAndBuzz

-- fizz :: Int -> Bool
on fizz(n)
    n mod 3 = 0
end fizz

-- buzz :: Int -> Bool
on buzz(n)
    n mod 5 = 0
end buzz


-- GENERIC LIBRARY FUNCTIONS

-- caseOf :: a -> [(predicate, b)] -> Maybe b -> Maybe b
on caseOf(e, lstPV, default)
    repeat with lstCase in lstPV
        set {p, v} to contents of lstCase
        if mReturn(p)'s lambda(e) then return v
    end repeat
    return default
end caseOf

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

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

-- range :: Int -> Int -> [Int]
on range(m, n)
    if n < m then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range
