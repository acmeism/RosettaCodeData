------------- APPROXIMATION OF THE VALUE OF E ------------

-- eApprox :: Int -> Float
on eApprox(n)
    -- The approximation of E obtained after N iterations.
    script go
        on |λ|(efl, x)
            set {e, fl} to efl
            set flx to fl * x

            {e + (1 / flx), flx}
        end |λ|
    end script

    item 1 of foldl(go, {1, 1}, enumFromTo(1, n))
end eApprox


--------------------------- TEST -------------------------
on run
    -- The approximation of E obtained after 20 iterations.
    eApprox(20)
end run


------------------------- GENERIC ------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set xs to {}
        repeat with i from m to n
            set end of xs to i
        end repeat
        xs
    else
        {}
    end if
end enumFromTo


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
