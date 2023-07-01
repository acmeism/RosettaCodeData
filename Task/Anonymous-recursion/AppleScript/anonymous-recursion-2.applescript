------------ ANONYMOUS RECURSION WITH THE Y-COMBINATOR --------
on run

    --------------------- FIBONACCI EXAMPLE -------------------

    script
        on |λ|(f)
            script
                on |λ|(n)
                    if 0 > n then return missing value
                    if 0 = n then return 0
                    if 1 = n then return 1
                    (f's |λ|(n - 2)) + (f's |λ|(n - 1))
                end |λ|
            end script
        end |λ|
    end script

    unlines(map(showList, chunksOf(12, ¬
        map(|Y|(result), enumFromTo(-2, 20)))))
end run


------------------------ Y COMBINATOR ----------------------

on |Y|(f)
    script
        on |λ|(y)
            script
                on |λ|(x)
                    y's |λ|(y)'s |λ|(x)
                end |λ|
            end script

            f's |λ|(result)
        end |λ|
    end script

    result's |λ|(result)
end |Y|


----------- GENERIC FUNCTIONS FOR TEST AND DISPLAY ---------

-- chunksOf :: Int -> [a] -> [[a]]
on chunksOf(k, xs)
    script
        on go(ys)
            set ab to splitAt(k, ys)
            set a to item 1 of ab
            if {} ≠ a then
                {a} & go(item 2 of ab)
            else
                a
            end if
        end go
    end script
    result's go(xs)
end chunksOf


-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
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
end enumFromTo


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


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


-- showList :: [a] -> String
on showList(xs)
    intercalate(", ", map(my str, xs))
end showList


-- splitAt :: Int -> [a] -> ([a], [a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            {items 1 thru n of xs as text, ¬
                items (n + 1) thru -1 of xs as text}
        else
            {items 1 thru n of xs, items (n + 1) thru -1 of xs}
        end if
    else
        if n < 1 then
            {{}, xs}
        else
            {xs, {}}
        end if
    end if
end splitAt


-- str :: a -> String
on str(x)
    x as string
end str


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
