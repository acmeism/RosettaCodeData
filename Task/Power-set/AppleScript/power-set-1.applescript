-- POWER SET -----------------------------------------------------------------

-- powerset :: [a] -> [[a]]
on powerset(xs)
    script subSet
        on |λ|(acc, x)
            script cons
                on |λ|(y)
                    {x} & y
                end |λ|
            end script

            acc & map(cons, acc)
        end |λ|
    end script

    foldr(subSet, {{}}, xs)
end powerset


-- TEST ----------------------------------------------------------------------
on run
    script test
        on |λ|(x)
            set {setName, setMembers} to x
            {setName, powerset(setMembers)}
        end |λ|
    end script

    map(test, [¬
        ["Set [1,2,3]", {1, 2, 3}], ¬
        ["Empty set", {}], ¬
        ["Set containing only empty set", {{}}]])

    --> {{"Set [1,2,3]", {{}, {3}, {2}, {2, 3}, {1}, {1, 3}, {1, 2}, {1, 2, 3}}},
    -->  {"Empty set", {{}}},
    -->  {"Set containing only empty set", {{}, {{}}}}}
end run

-- GENERIC FUNCTIONS ---------------------------------------------------------

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldr

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
