on run

    set xs to {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    {map(square, xs), ¬
        filter(even, xs), ¬
        foldl(add, 0, xs)}

    --> {{1, 4, 9, 16, 25, 36, 49, 64, 81, 100}, {2, 4, 6, 8, 10}, 55}

end run

-- square :: Num -> Num -> Num
on square(x)
    x * x
end square

-- add :: Num -> Num -> Num
on add(a, b)
    a + b
end add

-- even :: Int -> Bool
on even(x)
    0 = x mod 2
end even


-- GENERIC HIGHER ORDER FUNCTIONS

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter

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

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

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
