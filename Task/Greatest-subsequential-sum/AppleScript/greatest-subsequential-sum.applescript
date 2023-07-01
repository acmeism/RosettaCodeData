-- maxSubseq :: [Int] -> [Int] -> (Int, [Int])
on maxSubseq(xs)
    script go
        on |λ|(ab, x)
            set a to fst(ab)
            set {m1, m2} to {fst(a), snd(a)}
            set high to max(Tuple(0, {}), Tuple(m1 + x, m2 & {x}))
            Tuple(high, max(snd(ab), high))
        end |λ|
    end script

    snd(foldl(go, Tuple(Tuple(0, {}), Tuple(0, {})), xs))
end maxSubseq


-- TEST ---------------------------------------------------
on run
    set mx to maxSubseq({-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1})
    {fst(mx), snd(mx)}
end run


-- GENERIC ABSTRACTIONS -----------------------------------

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl

-- gt :: Ord a => a -> a -> Bool
on gt(x, y)
    set c to class of x
    if record is c or list is c then
        fst(x) > fst(y)
    else
        x > y
    end if
end gt

-- fst :: (a, b) -> a
on fst(tpl)
    if class of tpl is record then
        |1| of tpl
    else
        item 1 of tpl
    end if
end fst

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

-- max :: Ord a => a -> a -> a
on max(x, y)
    if gt(x, y) then
        x
    else
        y
    end if
end max

-- snd :: (a, b) -> b
on snd(tpl)
    if class of tpl is record then
        |2| of tpl
    else
        item 2 of tpl
    end if
end snd

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple
