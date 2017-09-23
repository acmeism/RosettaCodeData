property tolerance : 1.0E-5

-- agm :: Num a => a -> a -> a
on agm(a, g)
    script withinTolerance
        on lambda(m)
            tell m to ((its an) - (its gn)) < tolerance
        end lambda
    end script

    script nextRefinement
        on lambda(m)
            tell m
                set {an, gn} to {its an, its gn}
                {an:(an + gn) / 2, gn:(an * gn) ^ 0.5}
            end tell
        end lambda
    end script

    an of |until|(withinTolerance, ¬
        nextRefinement, {an:(a + g) / 2, gn:(a * g) ^ 0.5})
end agm


-- TEST
on run

    agm(1, 1 / (2 ^ 0.5))

end run



-- GENERIC FUNCTIONS

-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set mp to mReturn(p)
    set v to x

    tell mReturn(f)
        repeat until mp's lambda(v)
            set v to lambda(v)
        end repeat
    end tell
    return v
end |until|

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
