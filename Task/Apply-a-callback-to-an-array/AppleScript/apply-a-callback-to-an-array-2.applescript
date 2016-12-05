on run

    set xs to {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    {map(square, xs), ¬
        filter(isEven, xs), ¬
        foldl(sum, 0, xs)}

    --> {{1, 4, 9, 16, 25, 36, 49, 64, 81, 100}, {2, 4, 6, 8, 10}, 55}

end run

-- square :: Num -> Num -> Num
on square(x)
    x * x
end square

-- sum :: Num -> Num -> Num
on sum(a, b)
    a + b
end sum

-- isEven :: Int -> Bool
on isEven(n)
    n mod 2 = 0
end isEven


-- GENERIC HIGHER ORDER FUNCTIONS

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

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if lambda(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property lambda : f
        end script
    end if
end mReturn
