-- maximumByMay :: (a -> a -> Ordering) -> [a] -> Maybe a
on maximumByMay(f, xs)
    set cmp to mReturn(f)
    script max
        on |λ|(a, b)
            if cmp's |λ|(a, b) < 0 then
                b
            else
                a
            end if
        end |λ|
    end script

    foldl1May(max, xs)
end maximumByMay

-- TEST -----------------------------------------------------------------------
on run

    set lstWords to ["alpha", "beta", "gamma", "delta", "epsilon", ¬
        "zeta", "eta", "theta", "iota", "kappa", "|λ|", "mu"]

    set lstCities to [{name:"Shanghai", population:24.15}, ¬
        {name:"Karachi", population:23.5}, ¬
        {name:"Beijing", population:21.5}, ¬
        {name:"Tianjin", population:14.7}, ¬
        {name:"Istanbul", population:14.4}, ¬
        {name:"Lagos", population:13.4}, ¬
        {name:"Tokyo", population:13.3}]

    script population
        on |λ|(x)
            population of x
        end |λ|
    end script


    return catMaybes({¬
        maximumByMay(comparing(|length|), lstWords), ¬
        maximumByMay(comparing(|length|), {}), ¬
        maximumByMay(comparing(population), lstCities)})

    --> {"epsilon", {name:"Shanghai", population:24.15}}

end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- catMaybes :: [Maybe a] -> [a]
on catMaybes(mbs)
    script emptyOrListed
        on |λ|(m)
            if nothing of m then
                {}
            else
                {just of m}
            end if
        end |λ|
    end script
    concatMap(emptyOrListed, mbs)
end catMaybes

-- comparing :: (a -> b) -> (a -> a -> Ordering)
on comparing(f)
    set mf to mReturn(f)
    script
        on |λ|(a, b)
            set x to mf's |λ|(a)
            set y to mf's |λ|(b)
            if x < y then
                -1
            else
                if x > y then
                    1
                else
                    0
                end if
            end if
        end |λ|
    end script
end comparing

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set acc to {}
    tell mReturn(f)
        repeat with x in xs
            set acc to acc & |λ|(contents of x)
        end repeat
    end tell
    return acc
end concatMap

-- foldl1May :: (a -> a -> a) -> [a] -> Maybe a
on foldl1May(f, xs)
    set lng to length of xs
    if lng > 0 then
        if lng > 1 then
            tell mReturn(f)
                set v to item 1 of xs
                set lng to length of xs
                repeat with i from 2 to lng
                    set v to |λ|(v, item i of xs, i, xs)
                end repeat
                return just(v)
            end tell
        else
            just(item 1 of xs)
        end if
    else
        nothing("Empty list")
    end if
end foldl1May

-- just :: a -> Just a
on just(x)
    {nothing:false, just:x}
end just

-- length :: [a] -> Int
on |length|(xs)
    length of xs
end |length|

-- max :: Ord a => a -> a -> a
on max(x, y)
    if x > y then
        x
    else
        y
    end if
end max

-- nothing :: () -> Nothing
on nothing(msg)
    {nothing:true, msg:msg}
end nothing

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
