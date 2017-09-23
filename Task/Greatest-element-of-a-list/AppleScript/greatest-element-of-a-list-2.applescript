-- maximumBy :: (a -> a -> Ordering) -> [a] -> a
on maximumBy(f, xs)
    set cmp to mReturn(f)
    script max
        on |λ|(a, b)
            if a is missing value or cmp's |λ|(a, b) < 0 then
                b
            else
                a
            end if
        end |λ|
    end script

    foldl(max, missing value, xs)
end maximumBy

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

    return {¬
        maximumBy(comparing(|length|), lstWords), ¬
        maximumBy(comparing(population), lstCities)}

    --> {"epsilon", {name:"Shanghai", population:24.15}}
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

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

-- length :: [a] -> Int
on |length|(xs)
    length of xs
end |length|

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
