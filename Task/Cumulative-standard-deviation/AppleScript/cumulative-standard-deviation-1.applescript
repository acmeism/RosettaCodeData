-------------- CUMULATIVE STANDARD DEVIATION -------------

-- stdDevInc :: Accumulator -> Num -> Index -> Accumulator
-- stdDevInc :: {sum:, squaresSum:, stages:} -> Real -> Integer
--                -> {sum:, squaresSum:, stages:}
on stdDevInc(a, n, i)
    set sum to (sum of a) + n
    set squaresSum to (squaresSum of a) + (n ^ 2)
    set stages to (stages of a) & ¬
        ((squaresSum / i) - ((sum / i) ^ 2)) ^ 0.5

    {sum:(sum of a) + n, squaresSum:squaresSum, stages:stages}
end stdDevInc


--------------------------- TEST -------------------------
on run
    set xs to [2, 4, 4, 4, 5, 5, 7, 9]

    stages of foldl(stdDevInc, ¬
        {sum:0, squaresSum:0, stages:[]}, xs)

    --> {0.0, 1.0, 0.942809041582, 0.866025403784, 0.979795897113, 1.0, 1.399708424448, 2.0}
end run



-------------------- GENERIC FUNCTIONS -------------------

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
