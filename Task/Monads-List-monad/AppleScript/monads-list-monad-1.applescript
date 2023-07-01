-- MONADIC FUNCTIONS (for list monad) ------------------------------------------

-- Monadic bind for lists is simply ConcatMap
-- which applies a function f directly to each value in the list,
-- and returns the set of results as a concat-flattened list

-- bind :: (a -> [b]) -> [a] -> [b]
on bind(f, xs)
    -- concat :: a -> a -> [a]
    script concat
        on |λ|(a, b)
            a & b
        end |λ|
    end script

    foldl(concat, {}, map(f, xs))
end bind

-- Monadic return/unit/inject for lists: just wraps a value in a list
-- a -> [a]
on unit(a)
    [a]
end unit

-- TEST ------------------------------------------------------------------------
on run
    -- Pythagorean triples drawn from integers in the range [1..n]
    -- {(x, y, z) | x <- [1..n], y <- [x+1..n], z <- [y+1..n], (x^2 + y^2 = z^2)}

    pythagoreanTriples(25)

    --> {{3, 4, 5}, {5, 12, 13}, {6, 8, 10}, {7, 24, 25}, {8, 15, 17},
    --   {9, 12, 15}, {12, 16, 20}, {15, 20, 25}}

end run

-- pythagoreanTriples :: Int -> [(Int, Int, Int)]
on pythagoreanTriples(maxInteger)
    script X
        on |λ|(X)
            script Y
                on |λ|(Y)
                    script Z
                        on |λ|(Z)
                            if X * X + Y * Y = Z * Z then
                                unit([X, Y, Z])
                            else
                                []
                            end if
                        end |λ|
                    end script

                    bind(Z, enumFromTo(1 + Y, maxInteger))
                end |λ|
            end script

            bind(Y, enumFromTo(1 + X, maxInteger))
        end |λ|
    end script

    bind(X, enumFromTo(1, maxInteger))

end pythagoreanTriples


-- GENERIC  FUNCTIONS ---------------------------------------------------------

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
