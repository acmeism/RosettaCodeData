-- Each comma-delimited string is mapped to a list of integers,
-- and these integer lists are concatenated together into a single list

-- expansion :: String -> [Int]
on expansion(strExpr)
    -- The string (between commas) is split on hyphens,
    -- and this segmentation is rewritten to ranges or minus signs
    -- and evaluated to lists of integer values

    -- signedRange :: String -> [Int]
    script signedRange
        -- After the first character, numbers preceded by an
        -- empty string (resulting from splitting on hyphens)
        -- and interpreted as negative

        -- signedIntegerAppended:: [Int] -> String -> Int -> [Int] -> [Int]
        on signedIntegerAppended(lstAccumulator, strNum, iPosn, lst)
            if strNum ≠ "" then
                if iPosn > 1 then
                    if length of (item (iPosn - 1) of lst) > 0 then
                        set strSign to ""
                    else
                        set strSign to "-"
                    end if
                else
                    set strSign to "+"
                end if
                lstAccumulator & ((strSign & strNum) as integer)
            else
                lstAccumulator
            end if
        end signedIntegerAppended

        on lambda(strHyphenated)
            tupleRange(foldl(signedIntegerAppended, {}, ¬
                splitOn("-", strHyphenated)))
        end lambda
    end script

    concatMap(signedRange, splitOn(",", strExpr))
end expansion


-- TEST
on run

    expansion("-6,-3--1,3-5,7-11,14,15,17-20")

    --> {-6, -3, -2, -1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20}
end run



-- GENERIC LIBRARY FUNCTIONS

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    script append
        on lambda(a, b)
            a & b
        end lambda
    end script

    foldl(append, {}, map(f, xs))
end concatMap

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

-- range :: (Int, Int) -> [Int]
on tupleRange(tuple)
    if tuple = {} then
        {}
    else if length of tuple > 1 then
        range(item 1 of tuple, item 2 of tuple)
    else
        item 1 of tuple
    end if
end tupleRange

-- range :: Int -> Int -> [Int]
on range(m, n)
    set d to cond(n < m, -1, 1)
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range

-- cond :: Bool -> (a -> b) -> (a -> b) -> (a -> b)
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set xs to text items of strMain
    set my text item delimiters to dlm
    return xs
end splitOn
