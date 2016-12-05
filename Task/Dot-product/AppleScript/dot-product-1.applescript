-- dotProduct :: [Number] -> [Number] -> Number
on dotProduct(xs, ys)
    script product
        on lambda(a, b)
            a * b
        end lambda
    end script

    if length of xs = length of ys then
        sum(zipWith(product, xs, ys))
    else
        missing value -- arrays of differing dimension
    end if
end dotProduct

-- sum :: [Number] -> Number
on sum(xs)
    script add
        on lambda(a, b)
            a + b
        end lambda
    end script

    foldl(add, 0, xs)
end sum


-- TEST
on run

    dotProduct([1, 3, -5], [4, -2, -1])

    --> 3
end run


-- GENERIC FUNCTIONS

-- all :: (a -> Bool) -> [a] -> Bool
on all(f, xs)
    tell mReturn(f)
        set lng to length of xs
        repeat with i from 1 to lng
            if not lambda(item i of xs) then return false
        end repeat
        true
    end tell
end all

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

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set nx to length of xs
    set ny to length of ys
    if nx < 1 or ny < 1 then
        {}
    else
        set lng to cond(nx < ny, nx, ny)
        set lst to {}
        tell mReturn(f)
            repeat with i from 1 to lng
                set end of lst to lambda(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith

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

-- cond :: Bool -> (a -> b) -> (a -> b) -> (a -> b)
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond
