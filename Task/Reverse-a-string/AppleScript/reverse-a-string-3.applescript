-- Using either a generic foldr(f, a, xs)

-- reverse1 :: [a] -> [a]
on reverse1(xs)
    script rev
        on |λ|(a, x)
            a & x
        end |λ|
    end script

    if class of xs is text then
        foldr(rev, {}, xs) as text
    else
        foldr(rev, {}, xs)
    end if
end reverse1

-- or the built-in reverse method for lists

-- reverse2 :: [a] -> [a]
on reverse2(xs)
    if class of xs is text then
        (reverse of characters of xs) as text
    else
        reverse of xs
    end if
end reverse2


-- TESTING reverse1 and reverse2 with same string and list ---------------------------------------------------------------------------
on run
    script test
        on |λ|(f)
            map(f, ["Hello there !", {1, 2, 3, 4, 5}])
        end |λ|
    end script

    map(test, [reverse1, reverse2])
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------------------------

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
