-- ARITHMETIC GEOMETRIC MEAN -------------------------------------------------

property tolerance : 1.0E-5

-- agm :: Num a => a -> a -> a
on agm(a, g)
    script withinTolerance
        on |λ|(m)
            tell m to ((its an) - (its gn)) < tolerance
        end |λ|
    end script

    script nextRefinement
        on |λ|(m)
            tell m
                set {an, gn} to {its an, its gn}
                {an:(an + gn) / 2, gn:(an * gn) ^ 0.5}
            end tell
        end |λ|
    end script

    an of |until|(withinTolerance, ¬
        nextRefinement, {an:(a + g) / 2, gn:(a * g) ^ 0.5})
end agm

-- TEST ----------------------------------------------------------------------
on run

    agm(1, 1 / (2 ^ 0.5))

    --> 0.847213084835

end run

-- GENERIC FUNCTIONS ---------------------------------------------------------

-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set mp to mReturn(p)
    set v to x
    tell mReturn(f)
        repeat until mp's |λ|(v)
            set v to |λ|(v)
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
            property |λ| : f
        end script
    end if
end mReturn
