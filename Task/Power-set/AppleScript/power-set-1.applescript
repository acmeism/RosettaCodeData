-- powerset :: [a] -> [[a]]
on powerset(xs)
    script subSet
        on lambda(acc, x)
            script consX
                on lambda(y)
                    {x} & y
                end lambda
            end script

            acc & map(consX, acc)
        end lambda
    end script

    foldr(subSet, {{}}, xs)
end powerset

--------------------------------------------------------------------------------------

-- TEST
on run
    script test
        on lambda(x)
            set {setName, setMembers} to x
            {setName, powerset(setMembers)}
        end lambda
    end script

    map(test, [¬
        ["Set [1,2,3]", {1, 2, 3}], ¬
        ["Empty set", {}], ¬
        ["Set containing only empty set", {{}}]])

    --> {{"Set [1,2,3]", {{}, {3}, {2}, {2, 3}, {1}, {1, 3}, {1, 2}, {1, 2, 3}}},
    -->  {"Empty set", {{}}},
    -->  {"Set containing only empty set", {{}, {{}}}}}

end run


-- GENERIC FUNCTIONS ---------------------------------------------------------------

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to lambda(v, item i of xs, i, xs)
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
            set end of lst to lambda(item i of xs, i, xs)
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
            property lambda : f
        end script
    end if
end mReturn
