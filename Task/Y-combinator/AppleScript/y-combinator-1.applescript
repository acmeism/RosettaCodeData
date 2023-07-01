-- Y COMBINATOR ---------------------------------------------------------------

on |Y|(f)
    script
        on |λ|(y)
            script
                on |λ|(x)
                    y's |λ|(y)'s |λ|(x)
                end |λ|
            end script

            f's |λ|(result)
        end |λ|
    end script

    result's |λ|(result)
end |Y|


-- TEST -----------------------------------------------------------------------
on run

    -- Factorial
    script fact
        on |λ|(f)
            script
                on |λ|(n)
                    if n = 0 then return 1
                    n * (f's |λ|(n - 1))
                end |λ|
            end script
        end |λ|
    end script


    -- Fibonacci
    script fib
        on |λ|(f)
            script
                on |λ|(n)
                    if n = 0 then return 0
                    if n = 1 then return 1
                    (f's |λ|(n - 2)) + (f's |λ|(n - 1))
                end |λ|
            end script
        end |λ|
    end script

    {facts:map(|Y|(fact), enumFromTo(0, 11)), fibs:map(|Y|(fib), enumFromTo(0, 20))}

    --> {facts:{1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800},

    --> fibs:{0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987,
    --           1597, 2584, 4181, 6765}}

end run


-- GENERIC FUNCTIONS FOR TEST -------------------------------------------------

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

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
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
end enumFromTo

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
