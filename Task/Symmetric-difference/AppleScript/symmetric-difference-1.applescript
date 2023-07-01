-- SYMMETRIC DIFFERENCE -------------------------------------------

-- symmetricDifference :: [a] -> [a] -> [a]
on symmetricDifference(xs, ys)
    union(difference(xs, ys), difference(ys, xs))
end symmetricDifference

-- TEST -----------------------------------------------------------
on run
    set a to ["John", "Serena", "Bob", "Mary", "Serena"]
    set b to ["Jim", "Mary", "John", "Jim", "Bob"]

    symmetricDifference(a, b)

    -->  {"Serena", "Jim"}
end run


-- GENERIC FUNCTIONS ----------------------------------------------

-- delete :: Eq a => a -> [a] -> [a]
on |delete|(x, xs)
    set mbIndex to elemIndex(x, xs)
    set lng to length of xs

    if mbIndex is not missing value then
        if lng > 1 then
            if mbIndex = 1 then
                items 2 thru -1 of xs
            else if mbIndex = lng then
                items 1 thru -2 of xs
            else
                tell xs to items 1 thru (mbIndex - 1) & ¬
                    items (mbIndex + 1) thru -1
            end if
        else
            {}
        end if
    else
        xs
    end if
end |delete|

-- difference :: [a] -> [a] -> [a]
on difference(xs, ys)
    script
        on |λ|(a, y)
            if a contains y then
                my |delete|(y, a)
            else
                a
            end if
        end |λ|
    end script

    foldl(result, xs, ys)
end difference

-- elemIndex :: a -> [a] -> Maybe Int
on elemIndex(x, xs)
    set lng to length of xs
    repeat with i from 1 to lng
        if x = (item i of xs) then return i
    end repeat
    return missing value
end elemIndex

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

-- nub :: [a] -> [a]
on nub(xs)
    if (length of xs) > 1 then
        set x to item 1 of xs
        [x] & nub(|delete|(x, items 2 thru -1 of xs))
    else
        xs
    end if
end nub

-- union :: [a] -> [a] -> [a]
on union(xs, ys)
    script flipDelete
        on |λ|(xs, x)
            my |delete|(x, xs)
        end |λ|
    end script

    set sx to nub(xs)
    sx & foldl(flipDelete, nub(ys), sx)
end union
