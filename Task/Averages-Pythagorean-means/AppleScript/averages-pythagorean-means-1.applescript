-- arithmetic_mean :: [Number] -> Number
on arithmetic_mean(xs)

    -- sum :: Number -> Number -> Number
    script sum
        on |λ|(accumulator, x)
            accumulator + x
        end |λ|
    end script

    foldl(sum, 0, xs) / (length of xs)
end arithmetic_mean

-- geometric_mean :: [Number] -> Number
on geometric_mean(xs)

    -- product :: Number -> Number -> Number
    script product
        on |λ|(accumulator, x)
            accumulator * x
        end |λ|
    end script

    foldl(product, 1, xs) ^ (1 / (length of xs))
end geometric_mean

-- harmonic_mean :: [Number] -> Number
on harmonic_mean(xs)

    -- addInverse :: Number -> Number -> Number
    script addInverse
        on |λ|(accumulator, x)
            accumulator + (1 / x)
        end |λ|
    end script

    (length of xs) / (foldl(addInverse, 0, xs))
end harmonic_mean

-- TEST -----------------------------------------------------------------------
on run
    set {A, G, H} to ap({arithmetic_mean, geometric_mean, harmonic_mean}, ¬
        {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}})

    {values:{arithmetic:A, geometric:G, harmonic:H}, inequalities:¬
        {|A >= G|:A ≥ G}, |G >= H|:G ≥ H}
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- A list of functions applied to a list of arguments
-- (<*> | ap) :: [(a -> b)] -> [a] -> [b]
on ap(fs, xs)
    set {nf, nx} to {length of fs, length of xs}
    set acc to {}
    repeat with i from 1 to nf
        tell mReturn(item i of fs)
            repeat with j from 1 to nx
                set end of acc to |λ|(contents of (item j of xs))
            end repeat
        end tell
    end repeat
    return acc
end ap

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
