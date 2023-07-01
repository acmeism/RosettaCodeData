-- MEDIAN ---------------------------------------------------------------------

-- median :: [Num] -> Num
on median(xs)
    -- nth :: [Num] -> Int -> Maybe Num
    script nth
        on |λ|(xxs, n)
            if length of xxs > 0 then
                set {x, xs} to uncons(xxs)

                script belowX
                    on |λ|(y)
                        y < x
                    end |λ|
                end script

                set {ys, zs} to partition(belowX, xs)
                set k to length of ys
                if k = n then
                    x
                else
                    if k > n then
                        |λ|(ys, n)
                    else
                        |λ|(zs, n - k - 1)
                    end if
                end if
            else
                missing value
            end if
        end |λ|
    end script

    set n to length of xs
    if n > 0 then
        tell nth
            if n mod 2 = 0 then
                (|λ|(xs, n div 2) + |λ|(xs, (n div 2) - 1)) / 2
            else
                |λ|(xs, n div 2)
            end if
        end tell
    else
        missing value
    end if
end median

-- TEST -----------------------------------------------------------------------
on run

    map(median, [¬
        [], ¬
        [5, 3, 4], ¬
        [5, 4, 2, 3], ¬
        [3, 4, 1, -8.4, 7.2, 4, 1, 1.2]])

    --> {missing value, 4, 3.5, 2.1}
end run

-- GENERIC FUNCTIONS ----------------------------------------------------------

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

-- partition :: predicate -> List -> (Matches, nonMatches)
-- partition :: (a -> Bool) -> [a] -> ([a], [a])
on partition(f, xs)
    tell mReturn(f)
        set lst to {{}, {}}
        repeat with x in xs
            set v to contents of x
            set end of item ((|λ|(v) as integer) + 1) of lst to v
        end repeat
    end tell
    {item 2 of lst, item 1 of lst}
end partition

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons
