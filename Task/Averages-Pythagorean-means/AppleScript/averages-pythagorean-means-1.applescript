-- arithmetic_mean :: [Number] -> Number
on arithmetic_mean(xs)

    -- sum :: Number -> Number -> Number
    script sum
        on lambda(accumulator, x)
            accumulator + x
        end lambda
    end script

    foldl(sum, 0, xs) / (length of xs)
end arithmetic_mean


-- geometric_mean :: [Number] -> Number
on geometric_mean(xs)

    -- product :: Number -> Number -> Number
    script product
        on lambda(accumulator, x)
            accumulator * x
        end lambda
    end script

    foldl(product, 1, xs) ^ (1 / (length of xs))
end geometric_mean


-- harmonic_mean :: [Number] -> Number
on harmonic_mean(xs)

    -- addInverse :: Number -> Number -> Number
    script addInverse
        on lambda(accumulator, x)
            accumulator + (1 / x)
        end lambda
    end script

    (length of xs) / (foldl(addInverse, 0, xs))
end harmonic_mean


-- TEST
on run

    script test
        on lambda(f)
            mReturn(f)'s lambda({1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
        end lambda
    end script


    set {A, G, H} to ¬
        map(test, {arithmetic_mean, geometric_mean, harmonic_mean})

    {values:{arithmetic:A, geometric:G, harmonic:H}, inequalities:¬
        {|A >= G|:A ≥ G}, |G >= H|:G ≥ H}
end run


---------------------------------------------------------------------------
-- GENERIC FUNCTIONS

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to lambda(v, item i of xs, i, xs)
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
