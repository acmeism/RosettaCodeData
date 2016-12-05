-- zigzagMatrix
on zigzagMatrix(n)

    -- diagonals :: n -> [[n]]
    script diagonals
        on lambda(n)
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

            diags(range(0, n * n - 1), 1, 1) of mf
        end lambda
    end script

    -- oddReversed :: [a] -> Int -> [a]
    script oddReversed
        on lambda(lst, i)
            if i mod 2 = 0 then
                lst
            else
                reverse of lst
            end if
        end lambda
    end script

    rowsFromDiagonals(n, map(oddReversed, lambda(n) of diagonals))

end zigzagMatrix


-- TEST
on run

    zigzagMatrix(5)

end run



-- Rows of given length from list of diagonals
-- rowsFromDiagonals :: Int -> [[a]] -> [[a]]
on rowsFromDiagonals(n, lst)
    if length of lst > 0 then

        -- lengthOverOne :: [a] -> Bool
        script lengthOverOne
            on lambda(lst)
                length of lst > 1
            end lambda
        end script

        set {edge, residue} to splitAt(n, lst)

        {map(my head, edge)} & ¬
            rowsFromDiagonals(n, ¬
                map(my tail, ¬
                    filter(lengthOverOne, edge)) & residue)
    else
        []
    end if
end rowsFromDiagonals


---------------------------------------------------------------------------

-- GENERIC FUNCTIONS

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if lambda(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to lambda(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

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

-- head :: [a] -> a
on head(xs)
    if length of xs > 0 then
        item 1 of xs
    else
        missing value
    end if
end head

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail

-- range :: Int -> Int -> [Int]
on range(m, n)
    set d to 1
    if n < m then set d to -1
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range

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
