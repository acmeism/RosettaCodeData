------------------------ GENERATOR -------------------------

-- leo :: Int -> Int -> Int -> Generator [Int]
on leo(L0, L1, delta)
    script
        property x : L0
        property y : L1
        on |λ|()
            set n to x
            set {x, y} to {y, x + y + delta}
            return n
        end |λ|
    end script
end leo


--------------------------- TEST ---------------------------
on run
    set leonardo to leo(1, 1, 1)
    set fibonacci to leo(0, 1, 0)

    unlines({"First 25 Leonardo numbers:", ¬
        twoLines(take(25, leonardo)), "", ¬
        "First 25 Fibonacci numbers:", ¬
        twoLines(take(25, fibonacci))})
end run


------------------------ FORMATTING ------------------------

-- twoLines :: [Int] -> String
on twoLines(xs)
    script row
        on |λ|(ns)
            tab & intercalate(", ", ns)
        end |λ|
    end script
    return unlines(map(row, chunksOf(16, xs)))
end twoLines


------------------------- GENERIC --------------------------

-- chunksOf :: Int -> [a] -> [[a]]
on chunksOf(n, xs)
    set lng to length of xs
    script go
        on |λ|(a, i)
            set x to (i + n) - 1
            if x ≥ lng then
                a & {items i thru -1 of xs}
            else
                a & {items i thru x of xs}
            end if
        end |λ|
    end script
    foldl(go, {}, enumFromThenTo(1, n, lng))
end chunksOf


-- enumFromThenTo :: Int -> Int -> Int -> [Int]
on enumFromThenTo(x1, x2, y)
    set xs to {}
    set d to max(1, (x2 - x1))
    repeat with i from x1 to y by d
        set end of xs to i
    end repeat
    return xs
end enumFromThenTo


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


-- intercalate :: String -> [String] -> String
on intercalate(sep, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, sep}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end intercalate


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


-- max :: Ord a => a -> a -> a
on max(x, y)
    if x > y then
        x
    else
        y
    end if
end max


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
            set v to xs's |λ|()
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
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines
