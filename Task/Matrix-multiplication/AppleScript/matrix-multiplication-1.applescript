-- matrixMultiply :: [[n]] -> [[n]] -> [[n]]
to matrixMultiply(a, b)
    script rows
        property xs : transpose(b)

        on lambda(row)
            script columns
                on lambda(col)
                    dotProduct(row, col)
                end lambda
            end script

            map(columns, xs)
        end lambda
    end script

    map(rows, a)
end matrixMultiply



-- TEST

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


-- dotProduct :: [n] -> [n] -> Maybe n
on dotProduct(xs, ys)
    script product
        on lambda(a, b)
            a * b
        end lambda
    end script

    if length of xs is not length of ys then
        missing value
    else
        sum(zipWith(product, xs, ys))
    end if
end dotProduct

-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on lambda(_, iCol)
            script row
                on lambda(xs)
                    item iCol of xs
                end lambda
            end script

            map(row, xss)
        end lambda
    end script

    map(column, item 1 of xss)
end transpose

-- sum :: [n] -> n
on sum(xs)
    script add
        on lambda(a, b)
            a + b
        end lambda
    end script

    foldl(add, 0, xs)
end sum



-- GENERIC LIBRARY FUNCTIONS

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to lambda(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl

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

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to length of xs
    if lng is not length of ys then
        missing value
    else
        tell mReturn(f)
            set lst to {}
            repeat with i from 1 to lng
                set end of lst to lambda(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith

-- Script | Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property lambda : f
        end script
    end if
end mReturn
