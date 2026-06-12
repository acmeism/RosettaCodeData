use framework "Foundation"

------------------- DISTANCES FROM EDGE ------------------

-- distancesFromEdge :: Int -> [[Int]]
on distancesFromEdge(n)
    -- A matrix of minimum distances to the edge.

    script f
        on |λ|(row, col)
            minimum({row - 1, col - 1, n - row, n - col})
        end |λ|
    end script

    matrix(n, n, f)
end distancesFromEdge


--------------------------- TEST -------------------------
on run
    script test
        on |λ|(n)
            showMatrix(my distancesFromEdge(n)) & ¬
                linefeed
        end |λ|
    end script

    unlines(map(test, {25, 10, 9, 2, 1}))
end run


------------------------- GENERIC ------------------------

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


-- minimum :: Ord a => [a] -> a
on minimum(xs)
    set ca to current application
    unwrap((ca's NSArray's arrayWithArray:xs)'s ¬
        valueForKeyPath:"@min.self")
end minimum


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


-- unwrap :: NSValue -> a
on unwrap(nsValue)
    if nsValue is missing value then
        missing value
    else
        set ca to current application
        item 1 of ((ca's NSArray's arrayWithObject:nsValue) as list)
    end if
end unwrap


------------------------ FORMATTING ----------------------

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
        on |λ|(txt)
            if n > length of txt then
                text -n thru -1 of ((replicate(n, cFiller) as text) & txt)
            else
                txt
            end if
        end |λ|
    end script
end justifyRight


-- max :: Ord a => a -> a -> a
on max(x, y)
    if x > y then
        x
    else
        y
    end if
end max


-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> String -> String
on replicate(n, s)
    -- Egyptian multiplication - progressively doubling a list,
    -- appending stages of doubling to an accumulator where needed
    -- for binary assembly of a target length
    script p
        on |λ|({n})
            n ≤ 1
        end |λ|
    end script

    script f
        on |λ|({n, dbl, out})
            if (n mod 2) > 0 then
                set d to out & dbl
            else
                set d to out
            end if
            {n div 2, dbl & dbl, d}
        end |λ|
    end script

    set xs to |until|(p, f, {n, s, ""})
    item 2 of xs & item 3 of xs
end replicate


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


-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set v to x
    set mp to mReturn(p)
    set mf to mReturn(f)
    repeat until mp's |λ|(v)
        set v to mf's |λ|(v)
    end repeat
    v
end |until|


-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords
