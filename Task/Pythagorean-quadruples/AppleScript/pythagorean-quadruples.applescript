-- double :: Num -> Num
on double(x)
    x + x
end double

-- powersOfTwo :: Generator [Int]
on powersOfTwo()
    iterate(double, 1)
end powersOfTwo

on run
    -- Two infinite lists, from each of which we can draw an arbitrary number of initial terms

    set xs to powersOfTwo() -- {1, 2, 4, 8, 16, 32 ...

    set ys to fmapGen(timesFive, powersOfTwo()) -- {5, 10, 20, 40, 80, 160 ...


    -- Another infinite list, derived from the first two (sorted in rising value)

    set zs to mergeInOrder(xs, ys) -- {1, 2, 4, 5, 8, 10 ...


    -- Taking terms from the derived list while their value is below 2200 ...

    takeWhileGen(le2200, zs)

    --> {1, 2, 4, 5, 8, 10, 16, 20, 32, 40, 64, 80, 128, 160, 256, 320, 512, 640, 1024, 1280, 2048}
end run


-- le2200 :: Num -> Bool
on le2200(x)
    x ≤ 2200
end le2200

-- timesFive :: Num -> Num
on timesFive(x)
    5 * x
end timesFive


-- mergeInOrder :: Generator [Int] -> Generator [Int] -> Generator [Int]
on mergeInOrder(ga, gb)
    script
        property a : uncons(ga)
        property b : uncons(gb)
        on |λ|()
            if (Nothing of a or Nothing of b) then
                missing value
            else
                set ta to Just of a
                set tb to Just of b
                if |1| of ta < |1| of tb then
                    set a to uncons(|2| of ta)
                    return |1| of ta
                else
                    set b to uncons(|2| of tb)
                    return |1| of tb
                end if
            end if
        end |λ|
    end script
end mergeInOrder


-- GENERIC -----------------------------------------------------------------

-- fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
on fmapGen(f, gen)
    script
        property g : gen
        property mf : mReturn(f)'s |λ|
        on |λ|()
            set v to g's |λ|()
            if v is missing value then
                v
            else
                mf(v)
            end if
        end |λ|
    end script
end fmapGen

-- iterate :: (a -> a) -> a -> Gen [a]
on iterate(f, x)
    script
        property v : missing value
        property g : mReturn(f)'s |λ|
        on |λ|()
            if missing value is v then
                set v to x
            else
                set v to g(v)
            end if
            return v
        end |λ|
    end script
end iterate

-- Just :: a -> Maybe a
on Just(x)
    {type:"Maybe", Nothing:false, Just:x}
end Just

-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|

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

-- Nothing :: Maybe a
on Nothing()
    {type:"Maybe", Nothing:true}
end Nothing

-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    set c to class of xs
    if list is c then
        if 0 < n then
            items 1 thru min(n, length of xs) of xs
        else
            {}
        end if
    else if string is c then
        if 0 < n then
            text 1 thru min(n, length of xs) of xs
        else
            ""
        end if
    else if script is c then
        set ys to {}
        repeat with i from 1 to n
            set v to xs's |λ|()
            if missing value is v then
                return ys
            else
                set end of ys to v
            end if
        end repeat
        return ys
    else
        missing value
    end if
end take

-- takeWhileGen :: (a -> Bool) -> Gen [a] -> [a]
on takeWhileGen(p, xs)
    set ys to {}
    set v to |λ|() of xs
    tell mReturn(p)
        repeat while (|λ|(v))
            set end of ys to v
            set v to xs's |λ|()
        end repeat
    end tell
    return ys
end takeWhileGen

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    set lng to |length|(xs)
    if 0 = lng then
        Nothing()
    else
        if (2 ^ 29 - 1) as integer > lng then
            if class of xs is string then
                set cs to text items of xs
                Just(Tuple(item 1 of cs, rest of cs))
            else
                Just(Tuple(item 1 of xs, rest of xs))
            end if
        else
            Just(Tuple(item 1 of take(1, xs), xs))
        end if
    end if
end uncons
