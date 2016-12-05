-- UNION AND DIFFERENCE

-- union :: [a] -> [a] -> [a]
on union(xs, ys)
    nub(xs & ys)
end union

-- difference :: [a] -> [a] -> [a]
on difference(xs, ys)
    script except
        on lambda(a, y)
            if a contains y then
                |delete|(y, a)
            else
                a
            end if
        end lambda
    end script

    foldl(except, xs, ys)
end difference


-- TEST

on run

    set a to ["John", "Serena", "Bob", "Mary", "Serena"]
    set b to ["Jim", "Mary", "John", "Jim", "Bob"]


    -- 'Symmetric difference'

    union(difference(a, b), difference(b, a))

    -->  {"Serena", "Jim"}

end run


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

-- unique set of members of xs
-- nub :: [a] -> [a]
on nub(xs)
    if (length of xs) > 1 then
        set x to item 1 of xs
        [x] & nub(|delete|(x, items 2 thru -1 of xs))
    else
        xs
    end if
end nub

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons

-- deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
on deleteBy(fnEq, x, xs)
    if length of xs > 0 then
        set {h, t} to uncons(xs)
        if lambda(x, h) of mReturn(fnEq) then
            t
        else
            {h} & deleteBy(fnEq, x, t)
        end if
    else
        {}
    end if
end deleteBy

-- delete :: a -> [a] -> [a]
on |delete|(x, xs)
    script Eq
        on lambda(a, b)
            a = b
        end lambda
    end script

    deleteBy(Eq, x, xs)
end |delete|


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
