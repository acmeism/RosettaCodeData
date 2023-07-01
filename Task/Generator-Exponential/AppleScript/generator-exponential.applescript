----------------- EXPONENTIAL / GENERATOR ----------------

-- powers :: Gen [Int]
on powers(n)
    script f
        on |λ|(x)
            x ^ n as integer
        end |λ|
    end script
    fmapGen(f, enumFrom(0))
end powers


--------------------------- TEST -------------------------
on run
    take(10, ¬
        drop(20, ¬
            differenceGen(powers(2), powers(3))))

    --> {529, 576, 625, 676, 784, 841, 900, 961, 1024, 1089}
end run


------------------------- GENERIC ------------------------

-- Just :: a -> Maybe a
on Just(x)
    {type:"Maybe", Nothing:false, Just:x}
end Just


-- Nothing :: Maybe a
on Nothing()
    {type:"Maybe", Nothing:true}
end Nothing


-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple


-- differenceGen :: Gen [a] -> Gen [a] -> Gen [a]
on differenceGen(ga, gb)
    -- All values of ga except any
    -- already seen in gb.
    script
        property g : zipGen(ga, gb)
        property bs : {}
        property xy : missing value
        on |λ|()
            set xy to g's |λ|()
            if missing value is xy then
                xy
            else
                set x to |1| of xy
                set y to |2| of xy
                set bs to {y} & bs
                if bs contains x then
                    |λ|() -- Next in series.
                else
                    x
                end if
            end if
        end |λ|
    end script
end differenceGen


-- drop :: Int -> [a] -> [a]
-- drop :: Int -> String -> String
on drop(n, xs)
    set c to class of xs
    if script is not c then
        if string is not c then
            if n < length of xs then
                items (1 + n) thru -1 of xs
            else
                {}
            end if
        else
            if n < length of xs then
                text (1 + n) thru -1 of xs
            else
                ""
            end if
        end if
    else
        take(n, xs) -- consumed
        return xs
    end if
end drop


-- enumFrom :: Int -> [Int]
on enumFrom(x)
    script
        property v : missing value
        on |λ|()
            if missing value is not v then
                set v to 1 + v
            else
                set v to x
            end if
            return v
        end |λ|
    end script
end enumFrom


-- fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
on fmapGen(f, gen)
    script
        property g : mReturn(f)
        on |λ|()
            set v to gen's |λ|()
            if v is missing value then
                v
            else
                g's |λ|(v)
            end if
        end |λ|
    end script
end fmapGen


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
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


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
            set nxt to take(1, xs)
            if {} is nxt then
                Nothing()
            else
                Just(Tuple(item 1 of nxt, xs))
            end if
        end if
    end if
end uncons


-- zipGen :: Gen [a] -> Gen [b] -> Gen [(a, b)]
on zipGen(ga, gb)
    script
        property ma : missing value
        property mb : missing value
        on |λ|()
            if missing value is ma then
                set ma to uncons(ga)
                set mb to uncons(gb)
            end if
            if Nothing of ma or Nothing of mb then
                missing value
            else
                set ta to Just of ma
                set tb to Just of mb
                set x to Tuple(|1| of ta, |1| of tb)
                set ma to uncons(|2| of ta)
                set mb to uncons(|2| of tb)
                return x
            end if
        end |λ|
    end script
end zipGen
