--------------------- CHURCH NUMERALS --------------------

-- churchZero :: (a -> a) -> a -> a
on churchZero(f, x)
    x
end churchZero


-- churchSucc :: ((a -> a) -> a -> a) -> (a -> a) -> a -> a
on churchSucc(n)
    script
        on |λ|(f)
            script
                property mf : mReturn(f)
                on |λ|(x)
                    mf's |λ|(mReturn(n)'s |λ|(mf)'s |λ|(x))
                end |λ|
            end script
        end |λ|
    end script
end churchSucc


-- churchFromInt(n) :: Int -> (b -> b) -> b -> b
on churchFromInt(n)
    script
        on |λ|(f)
            foldr(my compose, my |id|, replicate(n, f))
        end |λ|
    end script
end churchFromInt


-- intFromChurch :: ((Int -> Int) -> Int -> Int) -> Int
on intFromChurch(cn)
    mReturn(cn)'s |λ|(my succ)'s |λ|(0)
end intFromChurch


on churchAdd(m, n)
    script
        on |λ|(f)
            script
                property mf : mReturn(m)
                property nf : mReturn(n)
                on |λ|(x)
                    nf's |λ|(f)'s |λ|(mf's |λ|(f)'s |λ|(x))
                end |λ|
            end script
        end |λ|
    end script
end churchAdd


on churchMult(m, n)
    script
        on |λ|(f)
            script
                property mf : mReturn(m)
                property nf : mReturn(n)
                on |λ|(x)
                    mf's |λ|(nf's |λ|(f))'s |λ|(x)
                end |λ|
            end script
        end |λ|
    end script
end churchMult


on churchExp(m, n)
    n's |λ|(m)
end churchExp


--------------------------- TEST -------------------------
on run
    set cThree to churchFromInt(3)
    set cFour to churchFromInt(4)

    map(intFromChurch, ¬
        {churchAdd(cThree, cFour), churchMult(cThree, cFour), ¬
            churchExp(cFour, cThree), churchExp(cThree, cFour)})
end run


------------------------- GENERIC ------------------------

-- compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
on compose(f, g)
    script
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            mf's |λ|(mg's |λ|(x))
        end |λ|
    end script
end compose


-- id :: a -> a
on |id|(x)
    x
end |id|


-- foldr :: (a -> b -> b) -> b -> [a] -> b
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(item i of xs, v, i, xs)
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
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if n < 1 then return out
    set dbl to {a}

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate


-- succ :: Int -> Int
on succ(x)
    1 + x
end succ
