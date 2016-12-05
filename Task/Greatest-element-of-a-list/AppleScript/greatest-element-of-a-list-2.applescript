-- maximumBy :: (a -> a -> Ordering) -> [a] -> a
on maximumBy(f, xs)
    script max
        property cmp : f
        on lambda(a, b)
            if a is missing value or cmp(a, b) < 0 then
                b
            else
                a
            end if
        end lambda
    end script

    foldl(max, missing value, xs)
end maximumBy


-- TEST
on run

    set lstWords to ["alpha", "beta", "gamma", "delta", "epsilon", ¬
        "zeta", "eta", "theta", "iota", "kappa", "lambda", "mu"]

    set lstCities to [{name:"Shanghai", population:24.15}, ¬
        {name:"Karachi", population:23.5}, ¬
        {name:"Beijing", population:21.5}, ¬
        {name:"Tianjin", population:14.7}, ¬
        {name:"Istanbul", population:14.4}, ¬
        {name:"Lagos", population:13.4}, ¬
        {name:"Tokyo", population:13.3}]

    return {¬
        maximumBy(wordAZ, lstWords), ¬
        maximumBy(wordZA, lstWords), ¬
        maximumBy(wordLong, lstWords), ¬
        maximumBy(wordShort, lstWords), ¬
        maximumBy(cityMostPopulation, lstCities), ¬
        maximumBy(cityLeastPopulation, lstCities), ¬
        maximumBy(cityNameAZ, lstCities), ¬
        maximumBy(cityNameZA, lstCities)}

end run


-- COMPARISON FUNCTIONS FOR SPECIFIC DATA TYPES
-- Ordering: (LT|EQ|GT)
-- GT: 1 (or other positive n)
-- EQ: 0
-- LT: -1 (or other negative n)

on wordAZ(a, b)
    if a < b then
        1
    else if a > b then
        -1
    else
        0
    end if
end wordAZ

on wordZA(a, b)
    if a < b then
        -1
    else if a > b then
        1
    else
        0
    end if
end wordZA

on wordLong(a, b)
    (length of a) - (length of b)
end wordLong

on wordShort(a, b)
    (length of b) - (length of a)
end wordShort

on cityMostPopulation(a, b)
    (population of a) - (population of b)
end cityMostPopulation

on cityLeastPopulation(a, b)
    (population of b) - (population of a)
end cityLeastPopulation

on cityNameAZ(a, b)
    set strA to name of a
    set strB to name of b

    if strA < strB then
        1
    else if strA > strB then
        -1
    else
        0
    end if
end cityNameAZ

on cityNameZA(a, b)
    set strA to name of a
    set strB to name of b

    if strA < strB then
        -1
    else if strA > strB then
        1
    else
        0
    end if
end cityNameZA


-- GENERIC LIBRARY FUNCTIONS

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to lambda(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl


-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property lambda : f
        end script
    end if
end mReturn
