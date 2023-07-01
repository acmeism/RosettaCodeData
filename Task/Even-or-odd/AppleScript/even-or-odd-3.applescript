----------------------- EVEN OR ODD ------------------------

-- even :: Int -> Bool
on even(n)
    0 = n mod 2
end even

-- odd :: Int -> Bool
on odd(n)
    not even(n)
end odd


--------------------------- TEST ---------------------------
on run

    partition(odd, enumFromTo(-6, 6))

    --> {{-5, -3, -1, 1, 3, 5}, {-6, -4, -2, 0, 2, 4, 6}}
end run


-------------------- GENERICS FOR TEST ---------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        lst
    else
        {}
    end if
end enumFromTo



-- partition :: (a -> Bool) -> [a] -> ([a], [a])
on partition(p, xs)
    tell mReturn(p)
        set {ys, zs} to {{}, {}}
        repeat with x in xs
            set v to contents of x
            if |λ|(v) then
                set end of ys to v
            else
                set end of zs to v
            end if
        end repeat
    end tell
    {ys, zs}
end partition


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn
