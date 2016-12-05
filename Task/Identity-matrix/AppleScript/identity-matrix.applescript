-- idMatrix :: Int -> [(0|1)]
on idMatrix(n)
    set xs to range(1, n)

    script row
        on lambda(x)
            script zeroOrOne
                on lambda(i)
                    cond(i = x, 1, 0)
                end lambda
            end script

            map(zeroOrOne, xs)
        end lambda
    end script

    map(row, xs)
end idMatrix


-- TEST
on run

    idMatrix(5)

end run



-- GENERIC FUNCTIONS ------------------------------------------

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

-- cond :: Bool -> a -> a -> a
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond

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
