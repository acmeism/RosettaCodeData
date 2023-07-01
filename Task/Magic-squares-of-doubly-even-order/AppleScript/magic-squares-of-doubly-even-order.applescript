-- MAGIC SQUARE OF DOUBLY EVEN ORDER -----------------------------------------

-- magicSquare :: Int -> [[Int]]
on magicSquare(n)
    if n mod 4 > 0 then
        {}
    else
        set sqr to n * n

        set maybePowerOfTwo to asPowerOfTwo(sqr)
        if maybePowerOfTwo is not missing value then

            -- For powers of 2, the (append not) 'magic' series directly
            -- yields the truth table that we need
            set truthSeries to magicSeries(maybePowerOfTwo)
        else
            -- where n is not a power of 2, we can replicate a
            -- minimum truth table, horizontally and vertically

            script scale
                on |λ|(x)
                    replicate(n / 4, x)
                end |λ|
            end script

            set truthSeries to ¬
                flatten(scale's |λ|(map(scale, splitEvery(4, magicSeries(4)))))
        end if

        set limit to sqr + 1
        script inOrderOrReversed
            on |λ|(x, i)
                cond(x, i, limit - i)
            end |λ|
        end script

        -- Taken directly from an integer series  [1..sqr] where True
        -- and from the reverse of that series where False
        splitEvery(n, map(inOrderOrReversed, truthSeries))
    end if
end magicSquare

-- magicSeries :: Int -> [Bool]
on magicSeries(n)
    script boolToggle
        on |λ|(x)
            not x
        end |λ|
    end script

    if n ≤ 0 then
        {true}
    else
        set xs to magicSeries(n - 1)
        xs & map(boolToggle, xs)
    end if
end magicSeries


-- TEST ----------------------------------------------------------------------
on run

    formattedTable(magicSquare(8))

end run

-- formattedTable :: [[Int]] -> String
on formattedTable(lstTable)
    set n to length of lstTable
    set w to 2.5 * n
    "magic(" & n & ")" & linefeed & wikiTable(lstTable, ¬
        false, "text-align:center;width:" & ¬
        w & "em;height:" & w & "em;table-layout:fixed;")
end formattedTable

-- wikiTable :: [Text] -> Bool -> Text -> Text
on wikiTable(lstRows, blnHdr, strStyle)
    script fWikiRows
        on |λ|(lstRow, iRow)
            set strDelim to cond(blnHdr and (iRow = 0), "!", "|")
            set strDbl to strDelim & strDelim
            linefeed & "|-" & linefeed & strDelim & space & ¬
                intercalate(space & strDbl & space, lstRow)
        end |λ|
    end script

    linefeed & "{| class=\"wikitable\" " & ¬
        cond(strStyle ≠ "", "style=\"" & strStyle & "\"", "") & ¬
        intercalate("", ¬
            map(fWikiRows, lstRows)) & linefeed & "|}" & linefeed
end wikiTable


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- asPowerOfTwo :: Int -> maybe Int
on asPowerOfTwo(n)
    if not isPowerOf(2, n) then
        missing value
    else
        set strCMD to ("echo 'l(" & n as string) & ")/l(2)' | bc -l"
        (do shell script strCMD) as integer
    end if
end asPowerOfTwo

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    script append
        on |λ|(a, b)
            a & b
        end |λ|
    end script

    foldl(append, {}, map(f, xs))
end concatMap

-- cond :: Bool -> a -> a -> a
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond

-- flatten :: Tree a -> [a]
on flatten(t)
    if class of t is list then
        concatMap(my flatten, t)
    else
        t
    end if
end flatten

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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- isPowerOf :: Int -> Int -> Bool
on isPowerOf(k, n)
    set v to k
    script remLeft
        on |λ|(x)
            x mod v is not 0
        end |λ|
    end script

    script integerDiv
        on |λ|(x)
            x div v
        end |λ|
    end script

    |until|(remLeft, integerDiv, n) = 1
end isPowerOf

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

-- splitAt :: Int -> [a] -> ([a],[a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            {items 1 thru n of xs as text, items (n + 1) thru -1 of xs as text}
        else
            {items 1 thru n of xs, items (n + 1) thru -1 of xs}
        end if
    else
        if n < 1 then
            {{}, xs}
        else
            {xs, {}}
        end if
    end if
end splitAt

-- splitEvery :: Int -> [a] -> [[a]]
on splitEvery(n, xs)
    if length of xs ≤ n then
        {xs}
    else
        set {gp, t} to splitAt(n, xs)
        {gp} & splitEvery(n, t)
    end if
end splitEvery

-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set mp to mReturn(p)
    set v to x

    tell mReturn(f)
        repeat until mp's |λ|(v)
            set v to |λ|(v)
        end repeat
    end tell
    return v
end |until|
