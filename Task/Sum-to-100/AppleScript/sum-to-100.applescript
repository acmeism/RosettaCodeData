use framework "Foundation" -- for basic NSArray sort

property pSigns : {1, 0, -1} --> ( + | unsigned | - )
property plst100 : {"Sums to 100:", ""}
property plstSums : {}
property plstSumsSorted : missing value
property plstSumGroups : missing value

-- data Sign :: [ 1 | 0 | -1 ] = ( Plus | Unsigned | Minus )
-- asSum :: [Sign] -> Int
on asSum(xs)
    script
        on |λ|(a, sign, i)
            if sign ≠ 0 then
                {digits:{}, n:(n of a) + (sign * ((i & digits of a) as string as integer))}
            else
                {digits:{i} & (digits of a), n:n of a}
            end if
        end |λ|
    end script

    set rec to foldr(result, {digits:{}, n:0}, xs)
    set ds to digits of rec
    if length of ds > 0 then
        (n of rec) + (ds as string as integer)
    else
        n of rec
    end if
end asSum

-- data Sign :: [ 1 | 0 | -1 ] = ( Plus | Unisigned | Minus )
-- asString :: [Sign] -> String
on asString(xs)
    script
        on |λ|(a, sign, i)
            set d to i as string
            if sign ≠ 0 then
                if sign > 0 then
                    a & " +" & d
                else
                    a & " -" & d
                end if
            else
                a & d
            end if
        end |λ|
    end script

    foldl(result, "", xs)
end asString

-- sumsTo100 :: () -> String
on sumsTo100()
    -- From first permutation without leading '+' (3 ^ 8) to end of universe (3 ^ 9)
    repeat with i from 6561 to 19683
        set xs to nthPermutationWithRepn(pSigns, 9, i)
        if asSum(xs) = 100 then set end of plst100 to asString(xs)
    end repeat
    intercalate(linefeed, plst100)
end sumsTo100


-- mostCommonSum :: () -> String
on mostCommonSum()
    -- From first permutation without leading '+' (3 ^ 8) to end of universe (3 ^ 9)
    repeat with i from 6561 to 19683
        set intSum to asSum(nthPermutationWithRepn(pSigns, 9, i))
        if intSum ≥ 0 then set end of plstSums to intSum
    end repeat

    set plstSumsSorted to sort(plstSums)
    set plstSumGroups to group(plstSumsSorted)

    script groupLength
        on |λ|(a, b)
            set intA to length of a
            set intB to length of b
            if intA < intB then
                -1
            else if intA > intB then
                1
            else
                0
            end if
        end |λ|
    end script

    set lstMaxSum to maximumBy(groupLength, plstSumGroups)
    intercalate(linefeed, ¬
        {"Most common sum: " & item 1 of lstMaxSum, ¬
            "Number of instances: " & length of lstMaxSum})
end mostCommonSum


-- TEST ----------------------------------------------------------------------
on run
    return sumsTo100()

    -- Also returns a value, but slow:
    -- mostCommonSum()
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- nthPermutationWithRepn :: [a] -> Int -> Int -> [a]
on nthPermutationWithRepn(xs, groupSize, iIndex)
    set intBase to length of xs
    set intSetSize to intBase ^ groupSize

    if intBase < 1 or iIndex > intSetSize then
        {}
    else
        set baseElems to inBaseElements(xs, iIndex)
        set intZeros to groupSize - (length of baseElems)

        if intZeros > 0 then
            replicate(intZeros, item 1 of xs) & baseElems
        else
            baseElems
        end if
    end if
end nthPermutationWithRepn

-- inBaseElements :: [a] -> Int -> [String]
on inBaseElements(xs, n)
    set intBase to length of xs

    script nextDigit
        on |λ|(residue)
            set {divided, remainder} to quotRem(residue, intBase)

            {valid:divided > 0, value:(item (remainder + 1) of xs), new:divided}
        end |λ|
    end script

    reverse of unfoldr(nextDigit, n)
end inBaseElements

-- sort :: [a] -> [a]
on sort(lst)
    ((current application's NSArray's arrayWithArray:lst)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort

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

-- group :: Eq a => [a] -> [[a]]
on group(xs)
    script eq
        on |λ|(a, b)
            a = b
        end |λ|
    end script

    groupBy(eq, xs)
end group

-- groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
on groupBy(f, xs)
    set mf to mReturn(f)

    script enGroup
        on |λ|(a, x)
            if length of (active of a) > 0 then
                set h to item 1 of active of a
            else
                set h to missing value
            end if

            if h is not missing value and mf's |λ|(h, x) then
                {active:(active of a) & x, sofar:sofar of a}
            else
                {active:{x}, sofar:(sofar of a) & {active of a}}
            end if
        end |λ|
    end script

    if length of xs > 0 then
        set dct to foldl(enGroup, {active:{item 1 of xs}, sofar:{}}, tail(xs))
        if length of (active of dct) > 0 then
            sofar of dct & {active of dct}
        else
            sofar of dct
        end if
    else
        {}
    end if
end groupBy

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail


-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

--  quotRem :: Integral a => a -> a -> (a, a)
on quotRem(m, n)
    {m div n, m mod n}
end quotRem

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

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldr

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

-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    set mf to mReturn(f)
    set lst to {}
    set recM to mf's |λ|(v)
    repeat while (valid of recM) is true
        set end of lst to value of recM
        set recM to mf's |λ|(new of recM)
    end repeat
    lst & value of recM
end unfoldr

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
