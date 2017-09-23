-- showBin :: Int -> String
on showBin(n)
    script binaryChar
        on |λ|(n)
            text item (n + 1) of "01"
        end |λ|
    end script
    showIntAtBase(2, binaryChar, n, "")
end showBin

-- GENERIC FUNCTIONS ----------------------------------------------------------

-- showIntAtBase :: Int -> (Int -> Char) -> Int -> String -> String
on showIntAtBase(base, toChr, n, rs)
    script showIt
        on |λ|(nd_, r)
            set {n, d} to nd_
            set r_ to toChr's |λ|(d) & r
            if n > 0 then
                |λ|(quotRem(n, base), r_)
            else
                r_
            end if
        end |λ|
    end script

    if base ≤ 1 then
        "error: showIntAtBase applied to unsupported base: " & base as string
    else if n < 0 then
        "error: showIntAtBase applied to negative number: " & base as string
    else
        showIt's |λ|(quotRem(n, base), rs)
    end if
end showIntAtBase

--  quotRem :: Integral a => a -> a -> (a, a)
on quotRem(m, n)
    {m div n, m mod n}
end quotRem

-- TEST -----------------------------------------------------------------------
on run
    script
        on |λ|(n)
            intercalate(" -> ", {n as string, showBin(n)})
        end |λ|
    end script

    return unlines(map(result, {5, 50, 9000}))
end run


-- GENERIC FUNCTIONS FOR TEST -------------------------------------------------

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

-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines
