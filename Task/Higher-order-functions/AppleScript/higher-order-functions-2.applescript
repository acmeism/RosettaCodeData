on run
    -- PASSING FUNCTIONS AS ARGUMENTS TO
    -- MAP, FOLD/REDUCE, AND FILTER, ACROSS A LIST

    set lstRange to {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    map(squared, lstRange)
    --> {0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100}

    foldl(summed, 0, map(squared, lstRange))
    --> 385

    filter(isEven, lstRange)
    --> {0, 2, 4, 6, 8, 10}


    -- OR MAPPING OVER A LIST OF FUNCTIONS

    map(testFunction, {doubled, squared, isEven})

    --> {{0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20},
    --    {0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100},
    --    {true, false, true, false, true, false, true, false, true, false, true}}
end run

-- testFunction :: (a -> b) -> [b]
on testFunction(f)
    map(f, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
end testFunction


-- MAP, REDUCE, FILTER

-- Returns a new list consisting of the results of applying the
-- provided function to each element of the first list
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

-- Applies a function against an accumulator and
-- each list element (from left-to-right) to reduce it
-- to a single return value

-- In some languages, like JavaScript, this is called reduce()

-- Arguments: function, initial value of accumulator, list
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


-- Sublist of those elements for which the predicate
-- function returns true
-- filter :: (a -> Bool) -> [a] -> [a]
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

-- HANDLER FUNCTIONS TO BE PASSED AS ARGUMENTS

-- squared :: Number -> Number
on squared(x)
    x * x
end squared

-- doubled :: Number -> Number
on doubled(x)
    x * 2
end doubled

-- summed :: Number -> Number -> Number
on summed(a, b)
    a + b
end summed

-- isEven :: Int -> Bool
on isEven(x)
    x mod 2 = 0
end isEven
