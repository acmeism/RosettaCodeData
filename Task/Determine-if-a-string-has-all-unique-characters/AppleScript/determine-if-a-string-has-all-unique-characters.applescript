use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

on run
    script showSource
        on |λ|(s)
            quoted("'", s) & " (" & length of s & ")"
        end |λ|
    end script

    script showDuplicate
        on |λ|(mb)
            script go
                on |λ|(tpl)
                    set {c, ixs} to tpl
                    quoted("'", c) & " at " & intercalate(", ", ixs)
                end |λ|
            end script
            maybe("None", go, mb)
        end |λ|
    end script

    fTable("Indices (1-based) of any duplicated characters:\n", ¬
        showSource, showDuplicate, ¬
        duplicatedCharIndices, ¬
        {"", ".", "abcABC", "XYZ ZYX", "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"})
end run


------------------CHARACTER DUPLICATIONS-------------------

-- duplicatedCharIndices :: String -> Maybe (Char, [Int])
on duplicatedCharIndices(s)
    script positionRecord
        on |λ|(dct, c, i)
            set k to (id of c) as string
            script additional
                on |λ|(xs)
                    insertDict(k, xs & i, dct)
                end |λ|
            end script
            maybe(insertDict(k, {i}, dct), additional, lookupDict(k, dct))
        end |λ|
    end script

    script firstDuplication
        on |λ|(sofar, idxs)
            set {iCode, xs} to idxs
            if 1 < length of xs then
                script earliest
                    on |λ|(kxs)
                        if item 1 of xs < (item 1 of (item 2 of kxs)) then
                            Just({chr(iCode), xs})
                        else
                            sofar
                        end if
                    end |λ|
                end script
                maybe(Just({chr(iCode), xs}), earliest, sofar)
            else
                sofar
            end if
        end |λ|
    end script

    foldl(firstDuplication, Nothing(), ¬
        assocs(foldl(positionRecord, {name:""}, chars(s))))
end duplicatedCharIndices


--------------------------GENERIC--------------------------

-- Just :: a -> Maybe a
on Just(x)
    -- Constructor for an inhabited Maybe (option type) value.
    -- Wrapper containing the result of a computation.
    {type:"Maybe", Nothing:false, Just:x}
end Just

-- Nothing :: Maybe a
on Nothing()
    -- Constructor for an empty Maybe (option type) value.
    -- Empty wrapper returned where a computation is not possible.
    {type:"Maybe", Nothing:true}
end Nothing

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    -- Constructor for a pair of values, possibly of two different types.
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple

-- assocs :: Map k a -> [(k, a)]
on assocs(m)
    script go
        on |λ|(k)
            set mb to lookupDict(k, m)
            if true = |Nothing| of mb then
                {}
            else
                {{k, |Just| of mb}}
            end if
        end |λ|
    end script
    concatMap(go, keys(m))
end assocs

-- keys :: Dict -> [String]
on keys(rec)
    (current application's ¬
        NSDictionary's dictionaryWithDictionary:rec)'s allKeys() as list
end keys

-- chr :: Int -> Char
on chr(n)
    character id n
end chr

-- chars :: String -> [Char]
on chars(s)
    characters of s
end chars

-- compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
on compose(f, g)
    script
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            mf's |λ|(mg's |λ|(x))
        end |λ|
    end script
end compose

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    return acc
end concatMap

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

-- fst :: (a, b) -> a
on fst(tpl)
    if class of tpl is record then
        |1| of tpl
    else
        item 1 of tpl
    end if
end fst

-- fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
on fTable(s, xShow, fxShow, f, xs)
    set ys to map(xShow, xs)
    set w to maximum(map(my |length|, ys))
    script arrowed
        on |λ|(a, b)
            justifyRight(w, space, a) & " -> " & b
        end |λ|
    end script
    s & linefeed & unlines(zipWith(arrowed, ¬
        ys, map(compose(fxShow, f), xs)))
end fTable

-- insertDict :: String -> a -> Dict -> Dict
on insertDict(k, v, rec)
    tell current application
        tell dictionaryWithDictionary_(rec) of its NSMutableDictionary
            its setValue:v forKey:(k as string)
            it as record
        end tell
    end tell
end insertDict

-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set str to xs as text
    set my text item delimiters to dlm
    str
end intercalate

-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller, strText)
    if n > length of strText then
        text -n thru -1 of ((replicate(n, cFiller) as text) & strText)
    else
        strText
    end if
end justifyRight

-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|

-- lookupDict :: a -> Dict -> Maybe b
on lookupDict(k, dct)
    -- Just the value of k in the dictionary,
    -- or Nothing if k is not found.
    set ca to current application
    set v to (ca's NSDictionary's dictionaryWithDictionary:dct)'s objectForKey:k
    if missing value ≠ v then
        Just(item 1 of ((ca's NSArray's arrayWithObject:v) as list))
    else
        Nothing()
    end if
end lookupDict

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- maximum :: Ord a => [a] -> a
on maximum(xs)
    script
        on |λ|(a, b)
            if a is missing value or b > a then
                b
            else
                a
            end if
        end |λ|
    end script

    foldl(result, missing value, xs)
end maximum

-- maybe :: b -> (a -> b) -> Maybe a -> b
on maybe(v, f, mb)
    -- The 'maybe' function takes a default value, a function, and a 'Maybe'
    -- value.  If the 'Maybe' value is 'Nothing', the function returns the
    -- default value.  Otherwise, it applies the function to the value inside
    -- the 'Just' and returns the result.
    if Nothing of mb then
        v
    else
        tell mReturn(f) to |λ|(Just of mb)
    end if
end maybe

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

-- quoted :: Char -> String -> String
on quoted(c, s)
    -- string flanked on both sides
    -- by a specified quote character.
    c & s & c
end quoted

-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if 1 > n then return out
    set dbl to {a}

    repeat while (1 < n)
        if 0 < (n mod 2) then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

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
            set v to |λ|() of xs
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

-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines

-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    zipWith(Tuple, xs, ys)
end zip

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(|length|(xs), |length|(ys))
    if 1 > lng then return {}
    set xs_ to take(lng, xs) -- Allow for non-finite
    set ys_ to take(lng, ys) -- generators like cycle etc
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs_, item i of ys_)
        end repeat
        return lst
    end tell
end zipWith
