-- NARCISSI -------------------------------------------------------------------

-- isDaffodil :: Int -> Int -> Bool
on isDaffodil(e, n)
    set ds to digitList(n)
    (e = length of ds) and (n = powerSum(e, ds))
end isDaffodil

-- digitList :: Int -> [Int]
on digitList(n)
    if n > 0 then
        {n mod 10} & digitList(n div 10)
    else
        {}
    end if
end digitList

-- powerSum :: Int -> [Int] -> Int
on powerSum(e, ns)
    script
        on |λ|(a, x)
            a + x ^ e
        end |λ|
    end script

    foldl(result, 0, ns) as integer
end powerSum

-- narcissiOfLength :: Int -> [Int]
on narcissiOfLength(nDigits)
    script nthPower
        on |λ|(x)
            {x, x ^ nDigits as integer}
        end |λ|
    end script
    set powers to map(nthPower, enumFromTo(0, 9))

    script combn
        on digitTree(n, parents)
            if n > 0 then
                if parents ≠ {} then
                    script nextLayer
                        on |λ|(pair)
                            set {digit, intSum} to pair
                            script addPower
                                on |λ|(dp)
                                    set {d, p} to dp
                                    {d, p + intSum}
                                end |λ|
                            end script

                            map(addPower, items 1 thru (digit + 1) of powers)
                        end |λ|
                    end script

                    set nodes to concatMap(nextLayer, parents)
                else
                    set nodes to powers
                end if
                digitTree(n - 1, nodes)
            else
                script
                    on |λ|(pair)
                        isDaffodil(nDigits, item 2 of pair)
                    end |λ|
                end script

                filter(result, parents)
            end if
        end digitTree
    end script

    script snd
        on |λ|(ab)
            item 2 of ab
        end |λ|
    end script
    map(snd, combn's digitTree(nDigits, {}))
end narcissiOfLength


-- TEST -----------------------------------------------------------------------
on run

    {0} & concatMap(narcissiOfLength, enumFromTo(1, 5))
    -- 4 seconds, 20 narcissi

    -- {0} & concatMap(narcissiOfLength, enumFromTo(1, 6))
    -- 103 seconds, 21 narcissi

    -- {0} & concatMap(narcissiOfLength, enumFromTo(1, 7))
    -- 13.75 minutes, 25 narcissi

end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lst to {}
    set lng to length of xs
    tell mReturn(f)
        repeat with i from 1 to lng
            set lst to (lst & |λ|(item i of xs, i, xs))
        end repeat
    end tell
    return lst
end concatMap

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if n < m then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end enumFromTo

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter

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

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

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
