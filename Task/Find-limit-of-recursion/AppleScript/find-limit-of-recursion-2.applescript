-- HIGHEST CHURCH NUMERAL REPRESENTABLE IN APPLESCRIPT ?

-- (This should be a good proxy for recursion depth)

on run
    script unrepresentable
        on |λ|(x)
            try
                churchFromInt(x)
                return false
            on error
                return true
            end try
            x > 10
        end |λ|
    end script

    "The highest Church-encoded integer representable in Applescript is " & ¬
        (|until|(unrepresentable, my succ, 0) - 1)
end run

-- CHURCH NUMERALS ------------------------------------------------------

-- chZero :: (a -> a) -> a -> a
on chZero(f)
    script
        on |λ|(x)
            x
        end |λ|
    end script
end chZero

-- chSucc :: ((a -> a) -> a -> a) -> (a -> a) -> a -> a
on chSucc(n)
    script
        on |λ|(f)
            script
                property mf : mReturn(f)'s |λ|
                on |λ|(x)
                    mf(mReturn(n)'s |λ|(mf)'s |λ|(x))
                end |λ|
            end script
        end |λ|
    end script
end chSucc

-- churchFromInt :: Int -> (a -> a) -> a -> a
on churchFromInt(x)
    script go
        on |λ|(i)
            if 0 < i then
                chSucc(|λ|(i - 1))
            else
                chZero
            end if
        end |λ|
    end script
    go's |λ|(x)
end churchFromInt

-- intFromChurch :: ((Int -> Int) -> Int -> Int) -> Int
on intFromChurch(cn)
    mReturn(cn)'s |λ|(my succ)'s |λ|(0)
end intFromChurch


-- GENERIC FUNCTIONS ----------------------------------------

-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set v to x
    set mp to mReturn(p)
    set mf to mReturn(f)
    repeat until mp's |λ|(v)
        set v to mf's |λ|(v)
    end repeat
end |until|

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

-- succ :: Enum a => a -> a
on succ(x)
    1 + x
end succ
