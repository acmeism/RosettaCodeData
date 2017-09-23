-- ID MATRIX -----------------------------------------------------------------

-- idMatrix :: Int -> [(0|1)]
on idMatrix(n)
    set xs to enumFromTo(1, n)

    script row
        on |λ|(x)
            script
                on |λ|(i)
                    if i = x then
                        1
                    else
                        0
                    end if
                end |λ|
            end script

            map(result, xs)
        end |λ|
    end script

    map(row, xs)
end idMatrix


-- TEST ----------------------------------------------------------------------
on run

    idMatrix(5)

end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

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
