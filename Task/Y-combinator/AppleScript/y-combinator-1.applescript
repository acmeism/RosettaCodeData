-- Y COMBINATOR

on |Y|(f)
    script
        on lambda(y)
            script
                on lambda(arg)
                    y's lambda(y)'s lambda(arg)
                end lambda
            end script

            f's lambda(result)

        end lambda
    end script

    result's lambda(result)
end |Y|


-- TEST
on run

    -- Factorial
    script fact
        on lambda(f)
            script
                on lambda(n)
                    if n = 0 then return 1
                    n * (f's lambda(n - 1))
                end lambda
            end script
        end lambda
    end script


    -- Fibonacci
    script fib
        on lambda(f)
            script
                on lambda(n)
                    if n = 0 then return 0
                    if n = 1 then return 1
                    (f's lambda(n - 2)) + (f's lambda(n - 1))
                end lambda
            end script
        end lambda
    end script

    {facts:map(|Y|(fact), range(0, 11)), fibs:map(|Y|(fib), range(0, 20))}

    --> {facts:{1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800},
    --> fibs:{0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765}}

end run


---------------------------------------------------------------------------


-- GENERIC FUNCTIONS (FOR TEST)

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
