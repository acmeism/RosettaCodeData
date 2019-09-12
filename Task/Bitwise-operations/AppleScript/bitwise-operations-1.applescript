use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

-- BIT OPERATIONS FOR APPLESCRIPT (VIA JAVASCRIPT FOR AUTOMATION)

-- bitAND :: Int -> Int -> Int
on bitAND(x, y)
    jsOp2("&", x, y)
end bitAND

-- bitOR :: Int -> Int -> Int
on bitOR(x, y)
    jsOp2("|", x, y)
end bitOR

-- bitXOr :: Int -> Int -> Int
on bitXOR(x, y)
    jsOp2("^", x, y)
end bitXOR

-- bitNOT :: Int -> Int
on bitNOT(x)
    jsOp1("~", x)
end bitNOT

-- (<<) :: Int -> Int -> Int
on |<<|(x, y)
    if 31 < y then
        0
    else
        jsOp2("<<", x, y)
    end if
end |<<|

-- Logical right shift
-- (>>>) :: Int -> Int -> Int
on |>>>|(x, y)
    jsOp2(">>>", x, y)
end |>>>|

-- Arithmetic right shift
-- (>>) :: Int -> Int -> Int
on |>>|(x, y)
    jsOp2(">>", x, y)
end |>>|


-- TEST ----------------------------------------------------------
on run
    -- Using an ObjC interface to Javascript for Automation

    set strClip to bitWise(255, 170)
    set the clipboard to strClip
    strClip
end run

-- bitWise :: Int -> Int -> String
on bitWise(a, b)
    set labels to {"a AND b", "a OR b", "a XOR b", "NOT a", ¬
        "a << b", "a >>> b", "a >> b"}
    set xs to {bitAND(a, b), bitOR(a, b), bitXOR(a, b), bitNOT(a), ¬
        |<<|(a, b), |>>>|(a, b), |>>|(a, b)}

    script asBin
        property arrow : " -> "
        on |λ|(x, y)
            justifyRight(8, space, x) & arrow & ¬
                justifyRight(14, space, y as text) & arrow & showBinary(y)
        end |λ|
    end script

    unlines({"32 bit signed integers   (in two's complement binary encoding)", "", ¬
        unlines(zipWith(asBin, ¬
            {"a = " & a as text, "b = " & b as text}, {a, b})), "", ¬
        unlines(zipWith(asBin, labels, xs))})
end bitWise

-- CONVERSIONS AND DISPLAY

-- bitsFromInt :: Int -> Either String [Bool]
on bitsFromIntLR(x)
    script go
        on |λ|(n, d, bools)
            set xs to {0 ≠ d} & bools
            if n > 0 then
                |λ|(n div 2, n mod 2, xs)
            else
                xs
            end if
        end |λ|
    end script

    set a to abs(x)
    if (2.147483647E+9) < a then
        |Left|("Integer overflow – maximum is (2 ^ 31) - 1")
    else
        set bs to go's |λ|(a div 2, a mod 2, {})
        if 0 > x then
            |Right|(replicate(32 - (length of bs), true) & ¬
                binSucc(map(my |not|, bs)))
        else
            set bs to go's |λ|(a div 2, a mod 2, {})
            |Right|(replicate(32 - (length of bs), false) & bs)
        end if
    end if
end bitsFromIntLR

-- Successor function (+1) for unsigned binary integer

-- binSucc :: [Bool] -> [Bool]
on binSucc(bs)
    script succ
        on |λ|(a, x)
            if a then
                if x then
                    Tuple(a, false)
                else
                    Tuple(x, true)
                end if
            else
                Tuple(a, x)
            end if
        end |λ|
    end script

    set tpl to mapAccumR(succ, true, bs)
    if |1| of tpl then
        {true} & |2| of tpl
    else
        |2| of tpl
    end if
end binSucc

-- showBinary :: Int -> String
on showBinary(x)
    script showBin
        on |λ|(xs)
            script bChar
                on |λ|(b)
                    if b then
                        "1"
                    else
                        "0"
                    end if
                end |λ|
            end script

            map(bChar, xs)
        end |λ|
    end script
    bindLR(my bitsFromIntLR(x), showBin)
end showBinary


-- JXA ------------------------------------------------------------------

--jsOp2 :: String -> a -> b -> c
on jsOp2(strOp, a, b)
    bindLR(evalJSLR(unwords({a as text, strOp, b as text})), my |id|) as integer
end jsOp2

--jsOp2 :: String -> a -> b
on jsOp1(strOp, a)
    bindLR(evalJSLR(unwords({strOp, a as text})), my |id|) as integer
end jsOp1

-- evalJSLR :: String -> Either String a
on evalJSLR(strJS)
    try -- NB if gJSC is global it must be released
        -- (e.g. set to null) at end of script
        gJSC's evaluateScript
    on error
        set gJSC to current application's JSContext's new()
        log ("new JSC")
    end try
    set v to unwrap((gJSC's evaluateScript:(strJS))'s toObject())
    if v is missing value then
        |Left|("JS evaluation error")
    else
        |Right|(v)
    end if
end evalJSLR

-- GENERIC FUNCTIONS --------------------------------------------------

-- Left :: a -> Either a b
on |Left|(x)
    {type:"Either", |Left|:x, |Right|:missing value}
end |Left|

-- Right :: b -> Either a b
on |Right|(x)
    {type:"Either", |Left|:missing value, |Right|:x}
end |Right|

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple

-- Absolute value.
-- abs :: Num -> Num
on abs(x)
    if 0 > x then
        -x
    else
        x
    end if
end abs

-- bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
on bindLR(m, mf)
    if missing value is not |Right| of m then
        mReturn(mf)'s |λ|(|Right| of m)
    else
        m
    end if
end bindLR

-- foldr :: (a -> b -> b) -> b -> [a] -> b
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(item i of xs, v, i, xs)
        end repeat
        return v
    end tell
end foldr

-- id :: a -> a
on |id|(x)
    x
end |id|

-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller, strText)
    if n > length of strText then
        text -n thru -1 of ((replicate(n, cFiller) as text) & strText)
    else
        strText
    end if
end justifyRight

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

-- 'The mapAccumR function behaves like a combination of map and foldr;
--  it applies a function to each element of a list, passing an accumulating
--  parameter from |Right| to |Left|, and returning a final value of this
--  accumulator together with the new list.' (see Hoogle)
-- mapAccumR :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
on mapAccumR(f, acc, xs)
    script
        on |λ|(x, a, i)
            tell mReturn(f) to set pair to |λ|(|1| of a, x, i)
            Tuple(|1| of pair, (|2| of pair) & |2| of a)
        end |λ|
    end script
    foldr(result, Tuple(acc, []), xs)
end mapAccumR

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

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

-- not :: Bool -> Bool
on |not|(p)
    not p
end |not|

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
    set {dlm, my text item delimiters} to {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords

-- unwrap :: NSObject -> a
on unwrap(objCValue)
    if objCValue is missing value then
        missing value
    else
        set ca to current application
        item 1 of ((ca's NSArray's arrayWithObject:objCValue) as list)
    end if
end unwrap

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    if 1 > lng then return {}
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys)
        end repeat
        return lst
    end tell
end zipWith
