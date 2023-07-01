-- applyN :: Int -> (a -> a) -> a -> a
on applyN(n, f, x)
    script go
        on |λ|(a, g)
            |λ|(a) of mReturn(g)
        end |λ|
    end script
    foldl(go, x, replicate(n, f))
end applyN


-------- SAMPLE FUNCTIONS FOR REPEATED APPLICATION --------

on double(x)
    2 * x
end double


on plusArrow(s)
    s & " -> "
end plusArrow


on squareRoot(n)
    n ^ 0.5
end squareRoot

-------------------------- TESTS --------------------------
on run
    log applyN(10, double, 1)
    --> 1024

    log applyN(5, plusArrow, "")
    --> " ->  ->  ->  ->  -> "

    log applyN(3, squareRoot, 65536)
    --> 4.0
end run


-------------------- GENERIC FUNCTIONS --------------------

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

-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if 1 > n then return out
    set dbl to {a}

    repeat while (1 < n)
        if 0 < (n mod 2) then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate
