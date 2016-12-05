-- knuthShuffle :: [a] -> [a]
on knuthShuffle(lst)

    -- randomSwap :: [Int] -> Int -> [Int]
    script randomSwap
        on lambda(a, i)
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
        end lambda
    end script

    foldr(randomSwap, lst, range(1, length of lst))
end knuthShuffle


-- TEST

on run
    knuthShuffle(["alpha", "beta", "gamma", "delta", "epsilon", ¬
        "zeta", "eta", "theta", "iota", "kappa", "lambda", "mu"])
end run



-- GENERIC LIBRARY FUNCTIONS

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

-- range :: Int -> Int -> [Int]
on range(m, n)
    if n < m then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range
