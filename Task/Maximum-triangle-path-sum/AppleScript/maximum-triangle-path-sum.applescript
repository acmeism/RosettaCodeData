-- MAX PATH SUM ---------------------------------------------------------------

-- Working from the bottom of the triangle upwards,
-- summing each number with the larger of the two below
-- until the maximum emerges at the top.

-- maxPathSum :: [[Int]] -> Int
on maxPathSum(xss)

    -- With the last row as the initial accumulator,
    -- folding from the penultimate line,
    -- towards the top of the triangle:

    -- sumWithRowBelow :: [Int] -> [Int] -> [Int]
    script sumWithRowBelow
        on |λ|(row, accum)

            -- plusGreaterOfTwoBelow :: Int -> Int -> Int -> Int
            script plusGreaterOfTwoBelow
                on |λ|(x, intLeft, intRight)
                    x + max(intLeft, intRight)
                end |λ|
            end script

            -- The accumulator, zipped with the tail of the
            -- accumulator, yields pairs of adjacent sums so far.

            zipWith3(plusGreaterOfTwoBelow, row, accum, tail(accum))
        end |λ|
    end script

    -- A list of lists folded down to a list of just one remaining integer.
    -- Head returns that integer from the list.

    head(foldr1(sumWithRowBelow, xss))
end maxPathSum


-- TEST -----------------------------------------------------------------------
on run

    maxPathSum({¬
        {55}, ¬
        {94, 48}, ¬
        {95, 30, 96}, ¬
        {77, 71, 26, 67}, ¬
        {97, 13, 76, 38, 45}, ¬
        {7, 36, 79, 16, 37, 68}, ¬
        {48, 7, 9, 18, 70, 26, 6}, ¬
        {18, 72, 79, 46, 59, 79, 29, 90}, ¬
        {20, 76, 87, 11, 32, 7, 7, 49, 18}, ¬
        {27, 83, 58, 35, 71, 11, 25, 57, 29, 85}, ¬
        {14, 64, 36, 96, 27, 11, 58, 56, 92, 18, 55}, ¬
        {2, 90, 3, 60, 48, 49, 41, 46, 33, 36, 47, 23}, ¬
        {92, 50, 48, 2, 36, 59, 42, 79, 72, 20, 82, 77, 42}, ¬
        {56, 78, 38, 80, 39, 75, 2, 71, 66, 66, 1, 3, 55, 72}, ¬
        {44, 25, 67, 84, 71, 67, 11, 61, 40, 57, 58, 89, 40, 56, 36}, ¬
        {85, 32, 25, 85, 57, 48, 84, 35, 47, 62, 17, 1, 1, 99, 89, 52}, ¬
        {6, 71, 28, 75, 94, 48, 37, 10, 23, 51, 6, 48, 53, 18, 74, 98, 15}, ¬
        {27, 2, 92, 23, 8, 71, 76, 84, 15, 52, 92, 63, 81, 10, 44, 10, 69, 93} ¬
            })

    --> 1320
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

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

-- foldr1 :: (a -> a -> a) -> [a] -> a
on foldr1(f, xs)
    if length of xs > 1 then
        tell mReturn(f)
            set v to item -1 of xs
            set lng to length of xs
            repeat with i from lng - 1 to 1 by -1
                set v to |λ|(item i of xs, v, i, xs)
            end repeat
            return v
        end tell
    else
        xs
    end if
end foldr1

-- head :: [a] -> a
on head(xs)
    if length of xs > 0 then
        item 1 of xs
    else
        missing value
    end if
end head

-- max :: Ord a => a -> a -> a
on max(x, y)
    if x > y then
        x
    else
        y
    end if
end max

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

-- minimum :: [a] -> a
on minimum(xs)
    script min
        on |λ|(a, x)
            if x < a or a is missing value then
                x
            else
                a
            end if
        end |λ|
    end script

    foldl(min, missing value, xs)
end minimum

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

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail

-- zipWith3 :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
on zipWith3(f, xs, ys, zs)
    set lng to minimum({length of xs, length of ys, length of zs})
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys, item i of zs)
        end repeat
        return lst
    end tell
end zipWith3
