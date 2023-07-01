-- PARTIAL APPLICATION --------------------------------------------

on f1(x)
    x * 2
end f1

on f2(x)
    x * x
end f2

on run

    tell curry(map)
        set fsf1 to |λ|(f1)
        set fsf2 to |λ|(f2)
    end tell

    {fsf1's |λ|({0, 1, 2, 3}), ¬
        fsf2's |λ|({0, 1, 2, 3}), ¬
        fsf1's |λ|({2, 4, 6, 8}), ¬
        fsf2's |λ|({2, 4, 6, 8})}
end run


-- GENERIC FUNCTIONS --------------------------------------------

-- curry :: (Script|Handler) -> Script
on curry(f)
    script
        on |λ|(a)
            script
                on |λ|(b)
                    |λ|(a, b) of mReturn(f)
                end |λ|
            end script
        end |λ|
    end script
end curry

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
