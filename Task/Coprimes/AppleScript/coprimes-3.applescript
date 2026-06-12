------------------------- COPRIME ------------------------

-- coprime :: Int -> Int -> Bool
on coprime(a, b)
    1 = gcd(a, b)
end coprime


--------------------------- TEST -------------------------
on run

    script test
        on |λ|(xy)
            set {x, y} to xy

            coprime(x, y)
        end |λ|
    end script

    filter(test, ¬
        {[21, 15], [17, 23], [36, 12], [18, 29], [60, 15]})
end run


------------------------- GENERIC ------------------------

-- abs :: Num -> Num
on abs(x)
    -- Absolute value.
    if 0 > x then
        -x
    else
        x
    end if
end abs


-- filter :: (a -> Bool) -> [a] -> [a]
on filter(p, xs)
    tell mReturn(p)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        lst
    end tell
end filter


-- gcd :: Int -> Int -> Int
on gcd(a, b)
    set x to abs(a)
    set y to abs(b)
    repeat until y = 0
        if x > y then
            set x to x - y
        else
            set y to y - x
        end if
    end repeat
    return x
end gcd


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn
