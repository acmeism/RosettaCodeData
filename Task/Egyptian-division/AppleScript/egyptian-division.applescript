-- EGYPTIAN DIVISION ------------------------------------

-- eqyptianQuotRem :: Int -> Int -> (Int, Int)
on egyptianQuotRem(m, n)
    script expansion
        on |λ|(ix)
            set {i, x} to ix
            if x > m then
                Nothing()
            else
                Just({ix, {i + i, x + x}})
            end if
        end |λ|
    end script

    script collapse
        on |λ|(ix, qr)
            set {i, x} to ix
            set {q, r} to qr
            if x < r then
                {q + i, r - x}
            else
                qr
            end if
        end |λ|
    end script

    return foldr(collapse, {0, m}, ¬
        unfoldr(expansion, {1, n}))
end egyptianQuotRem


-- TEST -------------------------------------------------
on run
    egyptianQuotRem(580, 34)
end run

-- GENERIC FUNCTIONS ------------------------------------

-- Just :: a -> Maybe a
on Just(x)
    {type:"Maybe", Nothing:false, Just:x}
end Just

-- Nothing :: Maybe a
on Nothing()
    {type:"Maybe", Nothing:true}
end Nothing

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

-- > unfoldr (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
-- > [10,9,8,7,6,5,4,3,2,1]
-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    set xr to {v, v} -- (value, remainder)
    set xs to {}
    tell mReturn(f)
        repeat -- Function applied to remainder.
            set mb to |λ|(item 2 of xr)
            if Nothing of mb then
                exit repeat
            else -- New (value, remainder) tuple,
                set xr to Just of mb
                -- and value appended to output list.
                set end of xs to item 1 of xr
            end if
        end repeat
    end tell
    return xs
end unfoldr
