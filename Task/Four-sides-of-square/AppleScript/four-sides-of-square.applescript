------------------- FOUR SIDES OF SQUARE -----------------


-- fourSides :: Int -> [[Int]]
on fourSides(n)
    -- A matrix of dimension n in which edge values are 1,
    -- and other values are zero.
    script go
        on |λ|(i, j)
            if {1, n} contains i or {1, n} contains j then
                1
            else
                0
            end if
        end |λ|
    end script

    matrix(n, n, go)
end fourSides


--------------------------- TEST -------------------------
on run
    -- Matrices of dimension 1 .. 6

    script test
        on |λ|(n)
            showMatrix(fourSides(n)) & linefeed & linefeed
        end |λ|
    end script

    unlines(map(test, enumFromTo(1, 6)))
end run


------------------------- MATRICES -----------------------

-- matrix :: Int -> Int -> ((Int, Int) -> a) -> [[a]]
on matrix(nRows, nCols, f)
    -- A matrix of a given number of columns and rows,
    -- in which each value is a given function of its
    -- (zero-based) column and row indices.
    script go
        property g : mReturn(f)'s |λ|

        on |λ|(iRow)
            set xs to {}
            repeat with iCol from 1 to nCols
                set end of xs to g(iRow, iCol)
            end repeat
            xs
        end |λ|
    end script

    map(go, enumFromTo(1, nRows))
end matrix


-- showMatrix :: [[Maybe a]] -> String
on showMatrix(rows)
    -- String representation of rows
    -- as a matrix.

    script showRow
        on |λ|(a, row)
            set {maxWidth, prevRows} to a
            script showCell
                on |λ|(acc, cell)
                    set {w, xs} to acc
                    if missing value is cell then
                        {w, xs & ""}
                    else
                        set s to cell as string
                        {max(w, length of s), xs & s}
                    end if
                end |λ|
            end script

            set {rowMax, cells} to foldl(showCell, {0, {}}, row)
            {max(maxWidth, rowMax), prevRows & {cells}}
        end |λ|
    end script

    set {w, stringRows} to foldl(showRow, {0, {}}, rows)
    script go
        on |λ|(row)
            unwords(map(justifyRight(w, space), row))
        end |λ|
    end script

    unlines(map(go, stringRows))
end showMatrix


------------------------- GENERIC ------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set xs to {}
        repeat with i from m to n
            set end of xs to i
        end repeat
        xs
    else
        {}
    end if
end enumFromTo


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


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller)
    script
        on |λ|(s)
            if n > length of s then
                text -n thru -1 of ((replicate(n, cFiller) as text) & s)
            else
                s
            end if
        end |λ|
    end script
end justifyRight


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
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


-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords
