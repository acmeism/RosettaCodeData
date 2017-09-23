-- matrixMultiply :: Num a => [[a]] -> [[a]] -> [[a]]
to matrixMultiply(a, b)
    script rows
        property xs : transpose(b)

        on |λ|(row)
            script columns
                on |λ|(col)
                    my dotProduct(row, col)
                end |λ|
            end script

            map(columns, xs)
        end |λ|
    end script

    map(rows, a)
end matrixMultiply


-- TEST -----------------------------------------------------------
on run
    matrixMultiply({¬
        {-1, 1, 4}, ¬
        {6, -4, 2}, ¬
        {-3, 5, 0}, ¬
        {3, 7, -2} ¬
            }, {¬
        {-1, 1, 4, 8}, ¬
        {6, 9, 10, 2}, ¬
        {11, -4, 5, -3}})

    --> {{51, -8, 26, -18}, {-8, -38, -6, 34},
    --     {33, 42, 38, -14}, {17, 74, 72, 44}}
end run


-- GENERIC FUNCTIONS ----------------------------------------------

-- dotProduct :: [n] -> [n] -> Maybe n
on dotProduct(xs, ys)
    script mult
        on |λ|(a, b)
            a * b
        end |λ|
    end script

    if length of xs is not length of ys then
        missing value
    else
        sum(zipWith(mult, xs, ys))
    end if
end dotProduct

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldr

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

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

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

-- product :: Num a => [a] -> a
on product(xs)
    script mult
        on |λ|(a, b)
            a * b
        end |λ|
    end script

    foldr(mult, 1, xs)
end product

-- sum :: Num a => [a] -> a
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldr(add, 0, xs)
end sum

-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on |λ|(_, iCol)
            script row
                on |λ|(xs)
                    item iCol of xs
                end |λ|
            end script

            map(row, xss)
        end |λ|
    end script

    map(column, item 1 of xss)
end transpose

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys)
        end repeat
        return lst
    end tell
end zipWith
