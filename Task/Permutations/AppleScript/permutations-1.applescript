----------------------- PERMUTATIONS -----------------------

-- permutations :: [a] -> [[a]]
on permutations(xs)
    script go
        on |λ|(xs)
            script h
                on |λ|(x)
                    script ts
                        on |λ|(ys)
                            {{x} & ys}
                        end |λ|
                    end script
                    concatMap(ts, go's |λ|(|delete|(x, xs)))
                end |λ|
            end script

            if {} ≠ xs then
                concatMap(h, xs)
            else
                {{}}
            end if
        end |λ|
    end script
    go's |λ|(xs)
end permutations


--------------------------- TEST ---------------------------
on run

    permutations({"aardvarks", "eat", "ants"})

end run


-------------------- GENERIC FUNCTIONS ---------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lst to {}
    set lng to length of xs
    tell mReturn(f)
        repeat with i from 1 to lng
            set lst to (lst & |λ|(contents of item i of xs, i, xs))
        end repeat
    end tell
    return lst
end concatMap


-- delete :: a -> [a] -> [a]
on |delete|(x, xs)
    if length of xs > 0 then
        set {h, t} to uncons(xs)
        if x = h then
            t
        else
            {h} & |delete|(x, t)
        end if
    else
        {}
    end if
end |delete|


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


-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons
