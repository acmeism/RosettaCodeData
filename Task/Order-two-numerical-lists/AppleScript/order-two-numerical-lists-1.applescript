-- <= for lists
-- compare :: [a] -> [a] -> Bool
on compare(xs, ys)
    if length of xs = 0 then
        true
    else
        if length of ys = 0 then
            false
        else
            set {hx, txs} to uncons(xs)
            set {hy, tys} to uncons(ys)

            if hx = hy then
                compare(txs, tys)
            else
                hx < hy
            end if
        end if
    end if
end compare



-- TEST
on run

    {compare([1, 2, 1, 3, 2], [1, 2, 0, 4, 4, 0, 0, 0]), ¬
        compare([1, 2, 0, 4, 4, 0, 0, 0], [1, 2, 1, 3, 2])}

end run


---------------------------------------------------------------------------

-- GENERIC FUNCTION

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons
