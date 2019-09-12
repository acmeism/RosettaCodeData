use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

-- BITWISE OPERATIONS FOR APPLESCRIPT ---------------------------------------

-- bitAND :: Int -> Int -> Int
on bitAND(x, y)
    bitOp2(my |and|, x, y)
end bitAND

-- bitOR :: Int -> Int -> Int
on bitOR(x, y)
    bitOp2(my |or|, x, y)
end bitOR

-- bitXOr :: Int -> Int -> Int
on bitXOR(x, y)
    bitOp2(my xor, x, y)
end bitXOR

-- bitNOT :: Int -> Int
on bitNOT(x)
    script notBits
        on |λ|(xs)
            bindLR(intFromBitsLR(map(my |not|, xs)), my |id|)
        end |λ|
    end script
    bindLR(bitsFromIntLR(x), notBits)
end bitNOT

-- (<<) :: Int -> Int -> Int
on |<<|(a, b)
    script logicLshift
        on |λ|(bs)
            bindLR(intFromBitsLR(take(32, drop(b, bs) & replicate(b, false))), my |id|)
        end |λ|
    end script
    bindLR(bitsFromIntLR(a), logicLshift)
end |<<|

-- Logical right shift
-- (>>>) :: Int -> Int -> Int
on |>>>|(a, b)
    script logicRShift
        on |λ|(bs)
            bindLR(intFromBitsLR(take(32, replicate(b, false) & drop(b, bs))), my |id|)
        end |λ|
    end script
    bindLR(bitsFromIntLR(a), logicRShift)
end |>>>|

-- Arithmetic right shift
-- (>>) :: Int -> Int -> Int
on |>>|(a, b)
    script arithRShift
        on |λ|(bs)
            if 0 < length of bs then
                set sign to item 1 of bs
            else
                set sign to false
            end if
            bindLR(intFromBitsLR(take(32, replicate(b, sign) & drop(b, bs))), my |id|)
        end |λ|
    end script
    bindLR(bitsFromIntLR(a), arithRShift)

end |>>|

-- bitRotL :: Int -> Int -> Int
on bitRotL(a, b)
    script lRot
        on |λ|(bs)
            bindLR(intFromBitsLR(rotate(-b, bs)), my |id|)
        end |λ|
    end script
    bindLR(bitsFromIntLR(a), lRot)
end bitRotL

-- bitRotR :: Int -> Int -> Int
on bitRotR(a, b)
    script rRot
        on |λ|(bs)
            bindLR(intFromBitsLR(rotate(b, bs)), my |id|)
        end |λ|
    end script
    bindLR(bitsFromIntLR(a), rRot)
end bitRotR

-- TEST ---------------------------------------------------------------

-- bitWise :: Int -> Int -> String
on bitWise(a, b)
    set labels to {"a AND b", "a OR b", "a XOR b", "NOT a", ¬
        "a << b", "a >>> b", "a >> b", "ROTL a b", "ROTR a b"}
    set xs to {bitAND(a, b), bitOR(a, b), bitXOR(a, b), bitNOT(a), ¬
        |<<|(a, b), |>>>|(a, b), |>>|(a, b), bitRotL(a, b), bitRotR(a, b)}

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

on run
    -- Assuming 32 bit signed integers (in two's complement binary encoding)

    set strClip to bitWise(255, 170)
    set the clipboard to strClip
    strClip
end run

-- BINARY INTEGER CONVERSIONS AND DISPLAY  ------------------------------------------------------------------

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

-- intFromBitsLR :: [Bool] -> Either String Int
on intFromBitsLR(xs)
    script bitSum
        on |λ|(x, a, i)
            if x then
                a + (2 ^ (31 - i))
            else
                a
            end if
        end |λ|
    end script

    set lngBits to length of xs
    if 32 < lngBits then
        |Left|("Applescript limited to signed 32 bit integers")
    else if 1 > lngBits then
        |Right|(0 as integer)
    else
        set bits to (rest of xs)
        if item 1 of xs then
            |Right|(0 - foldr(bitSum, 1, map(my |not|, bits)) as integer)
        else
            |Right|(foldr(bitSum, 0, bits) as integer)
        end if
    end if
end intFromBitsLR

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

-- bitOp2 :: ((Bool -> Bool -> Bool) -> Int -> Int -> Int
on bitOp2(f, x, y)
    script yBits
        on |λ|(bitX)
            script zipOp
                on |λ|(bitY)
                    bitZipWithLR(f, bitX, bitY)
                end |λ|
            end script
            bindLR(bindLR(bindLR(bitsFromIntLR(y), ¬
                zipOp), my intFromBitsLR), my |id|)
        end |λ|
    end script
    bindLR(bitsFromIntLR(x), yBits)
end bitOp2

-- bitZipWithLR ::  ((a, b) -> c ) -> [Bool] -> [Bool] -> Either String  [(Bool, Bool)]
on bitZipWithLR(f, xs, ys)
    set intX to length of xs
    set intY to length of ys
    set intMax to max(intX, intY)
    if 33 > intMax then
        if intX > intY then
            set {bxs, bys} to {xs, ys & replicate(intX - intY, false)}
        else
            set {bxs, bys} to {xs & replicate(intY - intX, false), ys}
        end if
        tell mReturn(f)
            set lst to {}
            repeat with i from 1 to intMax
                set end of lst to |λ|(item i of bxs, item i of bys)
            end repeat
            return |Right|(lst)
        end tell
    else
        |Left|("Above maximum of 32 bits")
    end if
end bitZipWithLR

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

-- BOOLEANS  ----------------------------------------------------

-- |or| :: Bool -> Bool -> Bool
on |or|(x, y)
    x or y
end |or|

-- |and| :: Bool -> Bool -> Bool
on |and|(x, y)
    x and y
end |and|

-- xor :: Bool -> Bool -> Bool
on xor(x, y)
    (x or y) and not (x and y)
end xor

-- not :: Bool -> Bool
on |not|(p)
    not p
end |not|

-- GENERAL ----------------------------------------------------

-- Right :: b -> Either a b
on |Right|(x)
    {type:"Either", |Left|:missing value, |Right|:x}
end |Right|

-- Left :: a -> Either a b
on |Left|(x)
    {type:"Either", |Left|:x, |Right|:missing value}
end |Left|

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

-- drop :: Int -> [a] -> [a]
-- drop :: Int -> String -> String
on drop(n, xs)
    if class of xs is not string then
        if n < length of xs then
            items (1 + n) thru -1 of xs
        else
            {}
        end if
    else
        if n < length of xs then
            text (1 + n) thru -1 of xs
        else
            ""
        end if
    end if
end drop

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

-- max :: Ord a => a -> a -> a
on max(x, y)
    if x > y then
        x
    else
        y
    end if
end max

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

-- rotate :: Int -> [a] -> [a]
on rotate(n, xs)
    set lng to length of xs
    if 0 > n then
        set d to (-n) mod lng
    else
        set d to lng - (n mod lng)
    end if
    drop(d, xs) & take(d, xs)
end rotate

-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    if class of xs is string then
        if 0 < n then
            text 1 thru min(n, length of xs) of xs
        else
            ""
        end if
    else
        if 0 < n then
            items 1 thru min(n, length of xs) of xs
        else
            {}
        end if
    end if
end take

-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines

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
