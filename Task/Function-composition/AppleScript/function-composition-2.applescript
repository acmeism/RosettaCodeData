-- Compose (right to left) a list of ordinary 2nd class handlers (of arbitrary length)

-- compose :: [(a -> a)] -> (a -> a)
on compose(fs)
    script
        on lambda(x)
            script
                on lambda(a, f)
                    mReturn(f)'s lambda(a)
                end lambda
            end script

            foldr(result, x, fs)
        end lambda
    end script
end compose


-- TEST

on root(x)
    x ^ 0.5
end root

on succ(x)
    x + 1
end succ

on half(x)
    x / 2
end half


on run

    tell compose([half, succ, root]) to lambda(5)

    --> 1.61803398875
end run



-- GENERIC FUNCTIONS

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to lambda(v, item i of xs, i, xs)
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
            property lambda : f
        end script
    end if
end mReturn
