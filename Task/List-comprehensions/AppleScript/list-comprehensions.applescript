-- List comprehension by direct and unsugared use of list monad

-- pythagoreanTriples :: Int -> [(Int, Int, Int)]
on pythagoreanTriples(n)
    script x
        on |λ|(x)
            script y
                on |λ|(y)
                    script z
                        on |λ|(z)
                            if x * x + y * y = z * z then
                                [[x, y, z]]
                            else
                                []
                            end if
                        end |λ|
                    end script

                    |>>=|(enumFromTo(1 + y, n), z)
                end |λ|
            end script

            |>>=|(enumFromTo(1 + x, n), y)
        end |λ|
    end script

    |>>=|(enumFromTo(1, n), x)
end pythagoreanTriples

-- TEST -----------------------------------------------------------------------
on run
    --   Pythagorean triples drawn from integers in the range [1..n]
    --  {(x, y, z) | x <- [1..n], y <- [x+1..n], z <- [y+1..n], (x^2 + y^2 = z^2)}

    pythagoreanTriples(25)

    --> {{3, 4, 5}, {5, 12, 13}, {6, 8, 10}, {7, 24, 25}, {8, 15, 17},
    --   {9, 12, 15}, {12, 16, 20}, {15, 20, 25}}
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- Monadic (>>=) (or 'bind') for lists is simply flip concatMap
-- (concatMap with arguments reversed)
-- It applies a function f directly to each value in the list,
-- and returns the set of results as a concat-flattened list

-- The concatenation eliminates any empty lists,
-- combining list-wrapped results into a single results list

-- (>>=) :: Monad m => m a -> (a -> m b) -> m b
on |>>=|(xs, f)
    concatMap(f, xs)
end |>>=|

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set acc to {}
    tell mReturn(f)
        repeat with x in xs
            set acc to acc & |λ|(contents of x)
        end repeat
    end tell
    return acc
end concatMap

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
