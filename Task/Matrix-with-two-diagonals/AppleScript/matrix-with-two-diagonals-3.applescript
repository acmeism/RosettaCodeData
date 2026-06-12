---------------- MATRIX WITH TWO DIAGONALS ---------------

-- bothDiagonals :: Int -> [[Int]]
on bothDiagonals(n)
    -- A square matrix of dimension n with ones
    -- along both diagonals, and zeros elsewhere.
    script idOrReflection
        on |λ|(x, y)
            ({y, 1 + n - y} contains x) as integer
        end |λ|
    end script

    matrix(n, n, idOrReflection)
end bothDiagonals


--------------------------- TEST -------------------------
on run
    -- Two diagonal matrices of dimensions 7 and 8

    unlines(map(compose(showMatrix, bothDiagonals), ¬
        {7, 8}))
end run


------------------------- GENERIC ------------------------

-- compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
on compose(f, g)
    script
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            mf's |λ|(mg's |λ|(x))
        end |λ|
    end script
end compose


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


-- showMatrix :: [[a]] -> String
on showMatrix(rows)
    -- String representation of a matrix.
    script
        on |λ|(cells)
            unwords(map(my str, cells))
        end |λ|
    end script

    unlines(map(result, rows)) & linefeed
end showMatrix


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


-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords
