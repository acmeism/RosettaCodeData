-- CHECK NESTING OF SQUARE BRACKET SEQUENCES ---------------------------------

-- Zero-based index of the first problem (-1 if none found):

-- imbalance :: String -> Integer
on imbalance(strBrackets)
    script
        on errorIndex(xs, iDepth, iIndex)
            set lngChars to length of xs
            if lngChars > 0 then
                set iNext to iDepth + cond(item 1 of xs = "[", 1, -1)

                if iNext < 0 then -- closing bracket unmatched
                    iIndex
                else
                    if lngChars > 1 then -- continue recursively
                        errorIndex(items 2 thru -1 of xs, iNext, iIndex + 1)
                    else -- end of string
                        cond(iNext = 0, -1, iIndex)
                    end if
                end if
            else
                cond(iDepth = 0, -1, iIndex)
            end if
        end errorIndex
    end script

    result's errorIndex(characters of strBrackets, 0, 0)
end imbalance

-- TEST ----------------------------------------------------------------------

-- Random bracket sequences for testing
-- brackets :: Int -> String
on randomBrackets(n)
    -- bracket :: () -> String
    script bracket
        on |λ|(_)
            cond((random number) < 0.5, "[", "]")
        end |λ|
    end script
    intercalate("", map(bracket, enumFromTo(1, n)))
end randomBrackets

on run
    set nPairs to 6

    -- report :: Int -> String
    script report
        property strPad : concat(replicate(nPairs * 2 + 4, space))

        on |λ|(n)
            set w to n * 2
            set s to randomBrackets(w)
            set i to imbalance(s)
            set blnOK to (i = -1)

            set strStatus to cond(blnOK, "OK", "problem")

            set strLine to "'" & s & "'" & ¬
                (items (w + 2) thru -1 of strPad) & strStatus

            set strPointer to cond(blnOK, ¬
                "", linefeed & concat(replicate(i + 1, space)) & "^")

            intercalate("", {strLine, strPointer})
        end |λ|
    end script

    linefeed & ¬
        intercalate(linefeed, ¬
            map(report, enumFromTo(1, nPairs))) & linefeed
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

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

-- Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- concat :: [[a]] -> [a] | [String] -> String
on concat(xs)
    script append
        on |λ|(a, b)
            a & b
        end |λ|
    end script

    if length of xs > 0 and class of (item 1 of xs) is string then
        set empty to ""
    else
        set empty to {}
    end if
    foldl(append, empty, xs)
end concat

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

-- Value of one of two expressions
-- cond ::  Bool -> a -> b -> c
on cond(bln, f, g)
    if bln then
        set e to f
    else
        set e to g
    end if
    if class of e is handler then
        mReturn(e)'s |λ|()
    else
        e
    end if
end cond

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
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
