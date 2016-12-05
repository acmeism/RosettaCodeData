-- disjointOrder :: String -> String -> String
on disjointOrder(m, n)
    set {ms, ns} to map(my |words|, {m, n})

    unwords(flatten(zip(segments(ms, ns), ns & "")))
end disjointOrder

-- segments :: [String] -> [String] -> [String]
on segments(ms, ns)
    script segmentation
        on lambda(a, x)
            set wds to |words| of a

            if wds contains x then
                {parts:(parts of a) & [current of a], current:[], |words|:deleteFirst(x, wds)}
            else
                {parts:(parts of a), current:(current of a) & x, |words|:wds}
            end if
        end lambda
    end script

    tell foldl(segmentation, {|words|:ns, parts:[], current:[]}, ms)
        (parts of it) & [current of it]
    end tell
end segments


-- TEST --------------------------------------------------------------------------------------
on run
    script order
        on lambda(rec)
            tell rec
                [its m, its n, my disjointOrder(its m, its n)]
            end tell
        end lambda
    end script

    arrowTable(map(order, [¬
        {m:"the cat sat on the mat", n:"mat cat"}, ¬
        {m:"the cat sat on the mat", n:"cat mat"}, ¬
        {m:"A B C A B C A B C", n:"C A C A"}, ¬
        {m:"A B C A B D A B E", n:"E A D A"}, ¬
        {m:"A B", n:"B"}, {m:"A B", n:"B A"}, ¬
        {m:"A B B A", n:"B A"}]))

-- the cat sat on the mat  ->  mat cat  ->  the mat sat on the cat
-- the cat sat on the mat  ->  cat mat  ->  the cat sat on the mat
-- A B C A B C A B C       ->  C A C A  ->  C B A C B A A B C
-- A B C A B D A B E       ->  E A D A  ->  E B C A B D A B A
-- A B                     ->  B        ->  A B
-- A B                     ->  B A      ->  B A
-- A B B A                 ->  B A      ->  B A B A

end run


-- GENERIC FUNCTIONS ----------------------------------------------------------------------

-- Formatting test results

-- arrowTable :: [[String]] -> String
on arrowTable(rows)

    script leftAligned
        script width
            on lambda(a, b)
                (length of a) - (length of b)
            end lambda
        end script

        on lambda(col)
            set widest to length of maximumBy(width, col)

            script padding
                on lambda(s)
                    justifyLeft(widest, space, s)
                end lambda
            end script

            map(padding, col)
        end lambda
    end script

    script arrows
        on lambda(row)
            intercalate("  ->  ", row)
        end lambda
    end script

    intercalate(linefeed, ¬
        map(arrows, ¬
            transpose(map(leftAligned, transpose(rows)))))

end arrowTable

-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on lambda(_, iCol)
            script row
                on lambda(xs)
                    item iCol of xs
                end lambda
            end script

            map(row, xss)
        end lambda
    end script

    map(column, item 1 of xss)
end transpose

-- justifyLeft :: Int -> Char -> Text -> Text
on justifyLeft(n, cFiller, strText)
    if n > length of strText then
        text 1 thru n of (strText & replicate(n, cFiller))
    else
        strText
    end if
end justifyLeft

-- maximumBy :: (a -> a -> Ordering) -> [a] -> a
on maximumBy(f, xs)
    set cmp to mReturn(f)
    script max
        on lambda(a, b)
            if a is missing value or cmp's lambda(a, b) < 0 then
                b
            else
                a
            end if
        end lambda
    end script

    foldl(max, missing value, xs)
end maximumBy

-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length

-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if n < 1 then return out
    set dbl to {a}

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

-- List functions

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

-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    script pair
        on lambda(x, i)
            [x, item i of ys]
        end lambda
    end script

    map(pair, items 1 thru minimum([length of xs, length of ys]) of xs)
end zip

-- flatten :: Tree a -> [a]
on flatten(t)
    if class of t is list then
        concatMap(my flatten, t)
    else
        t
    end if
end flatten

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    script append
        on lambda(a, b)
            a & b
        end lambda
    end script

    foldl(append, {}, map(f, xs))
end concatMap

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

-- deleteFirst :: a -> [a] -> [a]
on deleteFirst(x, xs)
    script Eq
        on lambda(a, b)
            a = b
        end lambda
    end script

    deleteBy(Eq, x, xs)
end deleteFirst

-- minimum :: [a] -> a
on minimum(xs)
    script min
        on lambda(a, x)
            if x < a or a is missing value then
                x
            else
                a
            end if
        end lambda
    end script

    foldl(min, missing value, xs)
end minimum

-- deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
on deleteBy(fnEq, x, xs)
    if length of xs > 0 then
        set {h, t} to uncons(xs)
        if lambda(x, h) of mReturn(fnEq) then
            t
        else
            {h} & deleteBy(fnEq, x, t)
        end if
    else
        {}
    end if
end deleteBy

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons

-- unwords :: [String] -> String
on unwords(xs)
    intercalate(space, xs)
end unwords

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- words :: String -> [String]
on |words|(s)
    words of s
end |words|
