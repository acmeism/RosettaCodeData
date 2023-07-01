-- offsets :: String -> String -> [Int]
on offsets(needle, haystack)
    script match
        property mx : length of haystack
        property d : (length of needle) - 1
        on |λ|(x, i, xs)
            set z to d + i
            mx ≥ z and needle = text i thru z of xs
        end |λ|
    end script

    findIndices(match, haystack)
end offsets


-- TEST ---------------------------------------------------
on run
    set txt to "I felt happy because I saw the others " & ¬
        "were happy and because I knew I should " & ¬
        "feel happy, but I wasn’t really happy."

    offsets("happy", txt)

    --> {8, 44, 83, 110}
end run


-- GENERIC -------------------------------------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    return acc
end concatMap


-- findIndices :: (a -> Bool) -> [a] -> [Int]
-- findIndices :: (String -> Bool) -> String -> [Int]
on findIndices(p, xs)
    script go
        property f : mReturn(p)
        on |λ|(x, i, xs)
            if f's |λ|(x, i, xs) then
                {i}
            else
                {}
            end if
        end |λ|
    end script
    concatMap(go, xs)
end findIndices


-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn
