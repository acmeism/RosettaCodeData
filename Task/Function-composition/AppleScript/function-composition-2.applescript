-- FUNCTIONS TO COMPOSE -------------------------------------------------------

on root(x)
    x ^ 0.5
end root

on succ(x)
    x + 1
end succ

on half(x)
    x / 2
end half

-- TEST -----------------------------------------------------------------------
on run

    compose([half, succ, root])'s |λ|(5)

    --> 1.61803398875
end run

-- GENERIC FUNCTIONS ----------------------------------------------------------

-- compose :: [(a -> a)] -> (a -> a)
on compose(fs)
    script
        on |λ|(x)
            script
                on |λ|(a, f)
                    mReturn(f)'s |λ|(a)
                end |λ|
            end script

            foldr(result, x, fs)
        end |λ|
    end script
end compose

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldr

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
