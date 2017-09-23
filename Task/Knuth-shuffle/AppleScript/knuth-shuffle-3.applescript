-- KNUTH SHUFFLE -------------------------------------------------------------

-- knuthShuffle :: [a] -> [a]
on knuthShuffle(xs)

    -- randomSwap :: [Int] -> Int -> [Int]
    script randomSwap
        on |λ|(a, i)
            if i > 1 then
                set iRand to random number from 1 to i
                tell a
                    set tmp to item iRand
                    set item iRand to item i
                    set item i to tmp
                    it
                end tell
            else
                a
            end if
        end |λ|
    end script

    foldr(randomSwap, xs, enumFromTo(1, length of xs))
end knuthShuffle


-- TEST ----------------------------------------------------------------------
on run
    knuthShuffle(["alpha", "beta", "gamma", "delta", "epsilon", ¬
        "zeta", "eta", "theta", "iota", "kappa", "lambda", "mu"])
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end enumFromTo

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
