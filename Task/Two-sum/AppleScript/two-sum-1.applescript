-------------------------- TWO SUM -------------------------

-- twoSum :: Int -> [Int] -> [(Int, Int)]
on twoSum(n, xs)
    set ixs to zip(enumFromTo(0, |length|(xs) - 1), xs)

    script ijIndices
        on |λ|(ix)
            set {i, x} to ix

            script jIndices
                on |λ|(jy)
                    set {j, y} to jy

                    if (x + y) = n then
                        {{i, j}}
                    else
                        {}
                    end if
                end |λ|
            end script

            |>>=|(drop(i + 1, ixs), jIndices)
        end |λ|
    end script

    |>>=|(ixs, ijIndices)
end twoSum


---------------------------- TEST --------------------------
on run
    twoSum(21, [0, 2, 11, 19, 90])

    --> {{1, 3}} Single solution.
end run


--------------------- GENERIC FUNCTIONS --------------------

-- (>>=) :: Monad m => m a -> (a -> m b) -> m b
on |>>=|(xs, f)
    concat(map(f, xs))
end |>>=|

-- concat :: [[a]] -> [a] | [String] -> String
on concat(xs)
    script append
        on |λ|(a, b)
            a & b
        end |λ|
    end script

    if length of xs > 0 and class of (item 1 of xs) is string then
        set empty to ""
    else
        set empty to {}
    end if
    foldl(append, empty, xs)
end concat

--  drop :: Int -> a -> a
on drop(n, a)
    if n < length of a then
        if class of a is text then
            text (n + 1) thru -1 of a
        else
            items (n + 1) thru -1 of a
        end if
    else
        {}
    end if
end drop

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
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

-- length :: [a] -> Int
on |length|(xs)
    length of xs
end |length|

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

-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to {item i of xs, item i of ys}
    end repeat
    return lst
end zip
