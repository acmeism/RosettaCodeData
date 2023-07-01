use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

-- MAYAN NUMBERS ------------------------------------------

-- mayanNumber:: Int -> [[String]]
on mayanNumber(n)
    showIntAtBase(20, my mayanDigit, n, {})
end mayanNumber

-- mayanDigit :: Int -> String
on mayanDigit(n)
    if 0 < n then
        set r to n mod 5
        bool({}, {concat(replicate(r, "●"))}, 0 < r) & ¬
            replicate(n div 5, "━━")
    else
        {"Θ"}
    end if
end mayanDigit

-- mayanFrame :: Int -> String
on mayanFrame(n)
    "Mayan " & (n as string) & ":\n" & wikiTable({|class|:¬
        "wikitable", colwidth:¬
        "3em", cell:¬
        "vertical-align:bottom;", |style|:¬
        "text-align:center;background-color:#F0EDDE;" & ¬
        "color:#605B4B;border:2px solid silver"})'s ¬
        |λ|({map(intercalateS("<br>"), mayanNumber(n))}) & "\n"
end mayanFrame

-- TEST ---------------------------------------------------

on run
    set str to unlines(map(mayanFrame, ¬
        {4005, 8017, 326205, 886205, 2978480}))

    set the clipboard to (str)
    return str
end run

-- GENERIC ------------------------------------------------

-- Just :: a -> Maybe a
on Just(x)
    {type:"Maybe", Nothing:false, Just:x}
end Just

-- Nothing :: Maybe a
on Nothing()
    {type:"Maybe", Nothing:true}
end Nothing

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple

-- bool :: a -> a -> Bool -> a
on bool(f, t, p)
    if p then
        t
    else
        f
    end if
end bool

-- concat :: [[a]] -> [a]
-- concat :: [String] -> String
on concat(xs)
    set lng to length of xs
    if 0 < lng and string is class of (item 1 of xs) then
        set acc to ""
    else
        set acc to {}
    end if
    repeat with i from 1 to lng
        set acc to acc & item i of xs
    end repeat
    acc
end concat

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

-- intercalateS :: String -> [String] -> String
on intercalateS(sep)
    script
        on |λ|(xs)
            set {dlm, my text item delimiters} to {my text item delimiters, sep}
            set s to xs as text
            set my text item delimiters to dlm
            return s
        end |λ|
    end script
end intercalateS

-- lookupDict :: a -> Dict -> Maybe b
on lookupDict(k, dct)
    set ca to current application
    set v to (ca's NSDictionary's dictionaryWithDictionary:dct)'s objectForKey:k
    if missing value ≠ v then
        Just(item 1 of ((ca's NSArray's arrayWithObject:v) as list))
    else
        Nothing()
    end if
end lookupDict

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

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


-- | The 'maybe' function takes a default value, a function, and a 'Maybe'
-- value.  If the 'Maybe' value is 'Nothing', the function returns the
-- default value.  Otherwise, it applies the function to the value inside
-- the 'Just' and returns the result.
-- maybe :: b -> (a -> b) -> Maybe a -> b
on maybe(v, f, mb)
    if Nothing of mb then
        v
    else
        tell mReturn(f) to |λ|(Just of mb)
    end if
end maybe

-- quotRem :: Int -> Int -> (Int, Int)
on quotRem(m, n)
    Tuple(m div n, m mod n)
end quotRem

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

-- showIntAtBase :: Int -> (Int -> [String]) -> Int -> String -> String
on showIntAtBase(base, toDigit, n, rs)
    script showIt
        property f : mReturn(toDigit)
        on |λ|(nd_, r)
            set {n, d} to ({|1|, |2|} of nd_)
            set r_ to {f's |λ|(d)} & r
            if n > 0 then
                |λ|(quotRem(n, base), r_)
            else
                r_
            end if
        end |λ|
    end script
    showIt's |λ|(quotRem(n, base), rs)
end showIntAtBase

-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines

-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords

-- wikiTable :: Dict -> [[String]] -> String
on wikiTable(opts)
    script ksv
        on |λ|(k)
            script
                on |λ|(s)
                    script
                        on |λ|(v)
                            k & v & s
                        end |λ|
                    end script
                end |λ|
            end script
        end |λ|
    end script
    script
        on |λ|(rows)
            script boxStyle
                on |λ|(a, k)
                    maybe(a, ksv's |λ|(a & k & "=\"")'s |λ|("\" "), ¬
                        lookupDict(k, opts))
                end |λ|
            end script
            script rowText
                on |λ|(row, iRow)
                    script cellText
                        on |λ|(cell)
                            if 1 = iRow then
                                set w to maybe("", ksv's |λ|("width:")'s |λ|(";"), ¬
                                    lookupDict("colwidth", opts))
                            else
                                set w to ""
                            end if
                            set s to maybe(w, ksv's |λ|(w)'s |λ|(""), ¬
                                lookupDict("cell", opts))
                            if 0 < length of s then
                                "style=\"" & s & "\"|" & cell
                            else
                                cell
                            end if
                        end |λ|
                    end script
                    intercalateS("\n|")'s |λ|(map(cellText, row))
                end |λ|
            end script
            "{| " & unwords(foldl(boxStyle, "", {"class", "style"})) & "\n|" & ¬
                intercalateS("\n|-\n")'s |λ|(map(rowText, rows)) & "\n|}"
        end |λ|
    end script
end wikiTable
