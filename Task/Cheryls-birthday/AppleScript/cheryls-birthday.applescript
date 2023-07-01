use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

property M : 1 -- Month
property D : 2 -- Day

on run
    -- The MONTH with only one remaining day
    -- among the DAYs with unique months,
    -- EXCLUDING months with unique days,
    -- in Cheryl's list:

    showList(uniquePairing(M, ¬
        uniquePairing(D, ¬
            monthsWithUniqueDays(false, ¬
                map(composeList({tupleFromList, |words|, toLower}), ¬
                    splitOn(", ", ¬
                        "May 15, May 16, May 19, June 17, June 18, " & ¬
                        "July 14, July 16, Aug 14, Aug 15, Aug 17"))))))

    --> "[('july', '16')]"
end run


-- QUERY FUNCTIONS ----------------------------------------

-- monthsWithUniqueDays :: Bool -> [(Month, Day)] -> [(Month, Day)]
on monthsWithUniqueDays(blnInclude, xs)
    set _months to map(my fst, uniquePairing(D, xs))
    script uniqueDay
        on |λ|(md)
            set bln to elem(fst(md), _months)
            if blnInclude then
                bln
            else
                not bln
            end if
        end |λ|
    end script
    filter(uniqueDay, xs)
end monthsWithUniqueDays


-- uniquePairing :: DatePart -> [(M, D)] -> [(M, D)]
on uniquePairing(dp, xs)
    script go
        property f : my mReturn(item dp of {my fst, my snd})
        on |λ|(md)

            set dct to f's |λ|(md)
            script unique
                on |λ|(k)
                    set mb to lookupDict(k, dct)
                    if Nothing of mb then
                        false
                    else
                        1 = length of (Just of mb)
                    end if
                end |λ|
            end script
            set uniques to filter(unique, keys(dct))

            script found
                on |λ|(tpl)
                    elem(f's |λ|(tpl), uniques)
                end |λ|
            end script
            filter(found, xs)
        end |λ|
    end script
    bindPairs(xs, go)
end uniquePairing


-- bindPairs :: [(M, D)] -> ((Dict Text [Text], Dict Text [Text])
--                                -> [(M, D)]) -> [(M, D)]
on bindPairs(xs, f)
    tell mReturn(f)
        |λ|(Tuple(dictFromPairs(xs), ¬
            dictFromPairs(map(my swap, xs))))
    end tell
end bindPairs

-- dictFromPairs :: [(M, D)] -> Dict Text [Text]
on dictFromPairs(mds)
    set gps to groupBy(|on|(my eq, my fst), ¬
        sortBy(comparing(my fst), mds))
    script kv
        on |λ|(gp)
            Tuple(fst(item 1 of gp), map(my snd, gp))
        end |λ|
    end script
    mapFromList(map(kv, gps))
end dictFromPairs


-- LIBRARY GENERICS ---------------------------------------

-- comparing :: (a -> b) -> (a -> a -> Ordering)
on comparing(f)
    script
        on |λ|(a, b)
            tell mReturn(f)
                set fa to |λ|(a)
                set fb to |λ|(b)
                if fa < fb then
                    -1
                else if fa > fb then
                    1
                else
                    0
                end if
            end tell
        end |λ|
    end script
end comparing

-- composeList :: [(a -> a)] -> (a -> a)
on composeList(fs)
    script
        on |λ|(x)
            script
                on |λ|(f, a)
                    mReturn(f)'s |λ|(a)
                end |λ|
            end script

            foldr(result, x, fs)
        end |λ|
    end script
end composeList

-- drop :: Int -> [a] -> [a]
-- drop :: Int -> String -> String
on drop(n, xs)
    set c to class of xs
    if c is not script then
        if c is not string then
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
    else
        take(n, xs) -- consumed
        return xs
    end if
end drop

-- dropAround :: (a -> Bool) -> [a] -> [a]
-- dropAround :: (Char -> Bool) -> String -> String
on dropAround(p, xs)
    dropWhile(p, dropWhileEnd(p, xs))
end dropAround

-- dropWhile :: (a -> Bool) -> [a] -> [a]
-- dropWhile :: (Char -> Bool) -> String -> String
on dropWhile(p, xs)
    set lng to length of xs
    set i to 1
    tell mReturn(p)
        repeat while i ≤ lng and |λ|(item i of xs)
            set i to i + 1
        end repeat
    end tell
    drop(i - 1, xs)
end dropWhile

-- dropWhileEnd :: (a -> Bool) -> [a] -> [a]
-- dropWhileEnd :: (Char -> Bool) -> String -> String
on dropWhileEnd(p, xs)
    set i to length of xs
    tell mReturn(p)
        repeat while i > 0 and |λ|(item i of xs)
            set i to i - 1
        end repeat
    end tell
    take(i, xs)
end dropWhileEnd

-- elem :: Eq a => a -> [a] -> Bool
on elem(x, xs)
    considering case
        xs contains x
    end considering
end elem

-- enumFromToInt :: Int -> Int -> [Int]
on enumFromToInt(M, n)
    if M ≤ n then
        set lst to {}
        repeat with i from M to n
            set end of lst to i
        end repeat
        return lst
    else
        return {}
    end if
end enumFromToInt

-- eq (==) :: Eq a => a -> a -> Bool
on eq(a, b)
    a = b
end eq

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter

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

-- fst :: (a, b) -> a
on fst(tpl)
    if class of tpl is record then
        |1| of tpl
    else
        item 1 of tpl
    end if
end fst

-- Typical usage: groupBy(on(eq, f), xs)
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
                {active:(active of a) & {x}, sofar:sofar of a}
            else
                {active:{x}, sofar:(sofar of a) & {active of a}}
            end if
        end |λ|
    end script

    if length of xs > 0 then
        set dct to foldl(enGroup, {active:{item 1 of xs}, sofar:{}}, rest of xs)
        if length of (active of dct) > 0 then
            sofar of dct & {active of dct}
        else
            sofar of dct
        end if
    else
        {}
    end if
end groupBy

-- insertMap :: Dict -> String -> a -> Dict
on insertMap(rec, k, v)
    tell (current application's NSMutableDictionary's ¬
        dictionaryWithDictionary:rec)
        its setValue:v forKey:(k as string)
        return it as record
    end tell
end insertMap

-- intercalateS :: String -> [String] -> String
on intercalateS(sep, xs)
    set {dlm, my text item delimiters} to {my text item delimiters, sep}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end intercalateS

-- Just :: a -> Maybe a
on Just(x)
    {type:"Maybe", Nothing:false, Just:x}
end Just

-- keys :: Dict -> [String]
on keys(rec)
    (current application's NSDictionary's dictionaryWithDictionary:rec)'s allKeys() as list
end keys

-- lookupDict :: a -> Dict -> Maybe b
on lookupDict(k, dct)
    set ca to current application
    set v to (ca's NSDictionary's dictionaryWithDictionary:dct)'s objectForKey:k
    if v ≠ missing value then
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

-- mapFromList :: [(k, v)] -> Dict
on mapFromList(kvs)
    set tpl to unzip(kvs)
    script
        on |λ|(x)
            x as string
        end |λ|
    end script
    (current application's NSDictionary's ¬
        dictionaryWithObjects:(|2| of tpl) ¬
            forKeys:map(result, |1| of tpl)) as record
end mapFromList

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

-- Nothing :: Maybe a
on Nothing()
    {type:"Maybe", Nothing:true}
end Nothing

-- e.g. sortBy(|on|(compare, |length|), ["epsilon", "mu", "gamma", "beta"])
-- on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
on |on|(f, g)
    script
        on |λ|(a, b)
            tell mReturn(g) to set {va, vb} to {|λ|(a), |λ|(b)}
            tell mReturn(f) to |λ|(va, vb)
        end |λ|
    end script
end |on|

-- partition :: predicate -> List -> (Matches, nonMatches)
-- partition :: (a -> Bool) -> [a] -> ([a], [a])
on partition(f, xs)
    tell mReturn(f)
        set ys to {}
        set zs to {}
        repeat with x in xs
            set v to contents of x
            if |λ|(v) then
                set end of ys to v
            else
                set end of zs to v
            end if
        end repeat
    end tell
    Tuple(ys, zs)
end partition

-- show :: a -> String
on show(e)
    set c to class of e
    if c = list then
        showList(e)
    else if c = record then
        set mb to lookupDict("type", e)
        if Nothing of mb then
            showDict(e)
        else
            script
                on |λ|(t)
                    if "Either" = t then
                        set f to my showLR
                    else if "Maybe" = t then
                        set f to my showMaybe
                    else if "Ordering" = t then
                        set f to my showOrdering
                    else if "Ratio" = t then
                        set f to my showRatio
                    else if class of t is text and t begins with "Tuple" then
                        set f to my showTuple
                    else
                        set f to my showDict
                    end if
                    tell mReturn(f) to |λ|(e)
                end |λ|
            end script
            tell result to |λ|(Just of mb)
        end if
    else if c = date then
        "\"" & showDate(e) & "\""
    else if c = text then
        "'" & e & "'"
    else if (c = integer or c = real) then
        e as text
    else if c = class then
        "null"
    else
        try
            e as text
        on error
            ("«" & c as text) & "»"
        end try
    end if
end show

-- showList :: [a] -> String
on showList(xs)
    "[" & intercalateS(", ", map(my show, xs)) & "]"
end showList

-- showTuple :: Tuple -> String
on showTuple(tpl)
    set ca to current application
    script
        on |λ|(n)
            set v to (ca's NSDictionary's dictionaryWithDictionary:tpl)'s objectForKey:(n as string)
            if v ≠ missing value then
                unQuoted(show(item 1 of ((ca's NSArray's arrayWithObject:v) as list)))
            else
                missing value
            end if
        end |λ|
    end script
    "(" & intercalateS(", ", map(result, enumFromToInt(1, length of tpl))) & ")"
end showTuple

-- snd :: (a, b) -> b
on snd(tpl)
    if class of tpl is record then
        |2| of tpl
    else
        item 2 of tpl
    end if
end snd

-- Enough for small scale sorts.
-- Use instead sortOn :: Ord b => (a -> b) -> [a] -> [a]
-- which is equivalent to the more flexible sortBy(comparing(f), xs)
-- and uses a much faster ObjC NSArray sort method
-- sortBy :: (a -> a -> Ordering) -> [a] -> [a]
on sortBy(f, xs)
    if length of xs > 1 then
        set h to item 1 of xs
        set f to mReturn(f)
        script
            on |λ|(x)
                f's |λ|(x, h) ≤ 0
            end |λ|
        end script
        set lessMore to partition(result, rest of xs)
        sortBy(f, |1| of lessMore) & {h} & ¬
            sortBy(f, |2| of lessMore)
    else
        xs
    end if
end sortBy

-- splitOn :: String -> String -> [String]
on splitOn(pat, src)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, pat}
    set xs to text items of src
    set my text item delimiters to dlm
    return xs
end splitOn

-- swap :: (a, b) -> (b, a)
on swap(ab)
    if class of ab is record then
        Tuple(|2| of ab, |1| of ab)
    else
        {item 2 of ab, item 1 of ab}
    end if
end swap

-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    set c to class of xs
    if list is c then
        if 0 < n then
            items 1 thru min(n, length of xs) of xs
        else
            {}
        end if
    else if string is c then
        if 0 < n then
            text 1 thru min(n, length of xs) of xs
        else
            ""
        end if
    else if script is c then
        set ys to {}
        repeat with i from 1 to n
            set v to xs's |λ|()
            if missing value is v then
                return ys
            else
                set end of ys to v
            end if
        end repeat
        return ys
    else
        missing value
    end if
end take

-- toLower :: String -> String
on toLower(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toLower

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple

-- tupleFromList :: [a] -> (a, a ...)
on tupleFromList(xs)
    set lng to length of xs
    if 1 < lng then
        if 2 < lng then
            set strSuffix to lng as string
        else
            set strSuffix to ""
        end if
        script kv
            on |λ|(a, x, i)
                insertMap(a, (i as string), x)
            end |λ|
        end script
        foldl(kv, {type:"Tuple" & strSuffix}, xs) & {length:lng}
    else
        missing value
    end if
end tupleFromList

-- unQuoted :: String -> String
on unQuoted(s)
    script p
        on |λ|(x)
            --{34, 39} contains id of x
            34 = id of x
        end |λ|
    end script
    dropAround(p, s)
end unQuoted

-- unzip :: [(a,b)] -> ([a],[b])
on unzip(xys)
    set xs to {}
    set ys to {}
    repeat with xy in xys
        set end of xs to |1| of xy
        set end of ys to |2| of xy
    end repeat
    return Tuple(xs, ys)
end unzip

-- words :: String -> [String]
on |words|(s)
    set ca to current application
    (((ca's NSString's stringWithString:(s))'s ¬
        componentsSeparatedByCharactersInSet:(ca's ¬
            NSCharacterSet's whitespaceAndNewlineCharacterSet()))'s ¬
        filteredArrayUsingPredicate:(ca's ¬
            NSPredicate's predicateWithFormat:"0 < length")) as list
end |words|
