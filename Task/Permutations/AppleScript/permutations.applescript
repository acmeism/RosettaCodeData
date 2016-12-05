-- permutations :: [a] -> [[a]]
on permutations(xs)
    script firstElement
        on lambda(x)
            script tailElements
                on lambda(ys)
                    {x & ys}
                end lambda
            end script

            concatMap(tailElements, permutations(|delete|(x, xs)))
        end lambda
    end script

    if length of xs > 0 then
        concatMap(firstElement, xs)
    else
        {{}}
    end if
end permutations


-- TEST
on run

    return permutations({1, 2, 3})
    permutations({"aardvarks", "eat", "ants"})

end run



-- GENERIC LIBRARY FUNCTIONS

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    script append
        on lambda(a, b)
            a & b
        end lambda
    end script

    foldl(append, {}, map(f, xs))
end concatMap

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

-- delete :: a -> [a] -> [a]
on |delete|(x, xs)
    script Eq
        on lambda(a, b)
            a = b
        end lambda
    end script

    deleteBy(Eq, x, xs)
end |delete|

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

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons

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
