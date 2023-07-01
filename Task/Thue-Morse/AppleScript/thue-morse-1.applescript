------------------------ THUE MORSE ----------------------

-- thueMorse :: Int -> String
on thueMorse(nCycles)
    script concatBinaryInverse
        on |λ|(xs)
            script binaryInverse
                on |λ|(x)
                    1 - x
                end |λ|
            end script

            xs & map(binaryInverse, xs)
        end |λ|
    end script

    intercalate("", ¬
        foldl(concatBinaryInverse, [0], ¬
            enumFromTo(1, nCycles)))
end thueMorse


--------------------------- TEST -------------------------
on run

    thueMorse(6)

    --> 0110100110010110100101100110100110010110011010010110100110010110
end run


------------------------- GENERIC ------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        lst
    else
        {}
    end if
end enumFromTo


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
