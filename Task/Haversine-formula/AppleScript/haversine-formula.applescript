use AppleScript version "2.4" -- Yosemite (10.10) or later
use framework "Foundation"
use framework "JavaScriptCore"
use scripting additions

property js : missing value


-- haversine :: (Num, Num) -> (Num, Num) -> Num
on haversine(latLong, latLong2)
    set {lat, lon} to latLong
    set {lat2, lon2} to latLong2

    set {rlat1, rlat2, rlon1, rlon2} to ¬
        map(my radians, {lat, lat2, lon, lon2})

    set dLat to rlat2 - rlat1
    set dLon to rlon2 - rlon1
    set radius to 6372.8 -- km

    set asin to math("asin")
    set sin to math("sin")
    set cos to math("cos")

    |round|((2 * radius * ¬
        (asin's |λ|((sqrt(((sin's |λ|(dLat / 2)) ^ 2) + ¬
            (((sin's |λ|(dLon / 2)) ^ 2) * ¬
                (cos's |λ|(rlat1)) * (cos's |λ|(rlat2)))))))) * 100) / 100
end haversine


-- math :: String -> Num -> Num
on math(f)
    script
        on |λ|(x)
            if missing value is js then ¬
                set js to current application's JSContext's new()
            (js's evaluateScript:("Math." & f & "(" & x & ")"))'s toDouble()
        end |λ|
    end script
end math


-------------------------- TEST ---------------------------
on run
    set distance to haversine({36.12, -86.67}, {33.94, -118.4})

    set js to missing value -- Clearing a c pointer.
    return distance
end run


-------------------- GENERIC FUNCTIONS --------------------

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map


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


-- radians :: Float x => Degrees x -> Radians x
on radians(x)
    (pi / 180) * x
end radians


-- round :: a -> Int
on |round|(n)
    round n
end |round|


-- sqrt :: Num -> Num
on sqrt(n)
    if n ≥ 0 then
        n ^ (1 / 2)
    else
        missing value
    end if
end sqrt
