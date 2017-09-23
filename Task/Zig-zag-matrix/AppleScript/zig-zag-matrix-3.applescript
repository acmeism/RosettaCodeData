-- zigzagMatrix
on zigzagMatrix(n)

    -- diagonals :: n -> [[n]]
    script diagonals
        on |λ|(n)
            script mf
                on diags(xs, iCol, iRow)
                    if (iCol < length of xs) then
                        if iRow < n then
                            set iNext to iCol + 1
                        else
                            set iNext to iCol - 1
                        end if

                        set {headList, tail} to splitAt(iCol, xs)
                        {headList} & diags(tail, iNext, iRow + 1)
                    else
                        {xs}
                    end if
                end diags
            end script

            diags(enumFromTo(0, n * n - 1), 1, 1) of mf
        end |λ|
    end script

    -- oddReversed :: [a] -> Int -> [a]
    script oddReversed
        on |λ|(lst, i)
            if i mod 2 = 0 then
                lst
            else
                reverse of lst
            end if
        end |λ|
    end script

    rowsFromDiagonals(n, map(oddReversed, |λ|(n) of diagonals))

end zigzagMatrix

-- Rows of given length from list of diagonals
-- rowsFromDiagonals :: Int -> [[a]] -> [[a]]
on rowsFromDiagonals(n, lst)
    if length of lst > 0 then

        -- lengthOverOne :: [a] -> Bool
        script lengthOverOne
            on |λ|(lst)
                length of lst > 1
            end |λ|
        end script

        set {edge, residue} to splitAt(n, lst)

        {map(my head, edge)} & ¬
            rowsFromDiagonals(n, ¬
                map(my tail, ¬
                    filter(lengthOverOne, edge)) & residue)
    else
        {}
    end if
end rowsFromDiagonals


-- TEST -----------------------------------------------------------------------
on run

    zigzagMatrix(5)

end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

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

-- head :: [a] -> a
on head(xs)
    if length of xs > 0 then
        item 1 of xs
    else
        missing value
    end if
end head

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

-- splitAt:: n -> list -> {n items from start of list, rest of list}
-- splitAt :: Int -> [a] -> ([a], [a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        {items 1 thru n of xs, items (n + 1) thru -1 of xs}
    else
        if n < 1 then
            {{}, xs}
        else
            {xs, {}}
        end if
    end if
end splitAt

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail
