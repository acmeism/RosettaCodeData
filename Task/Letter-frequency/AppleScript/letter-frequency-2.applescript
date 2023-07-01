use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


------------- CHARACTER COUNTS FROM FILE PATH -------------

-- charCounts :: FilePath -> Either String [(Char, Int)]
on charCounts(fp)
    script go
        on |λ|(s)
            |Right|(sortBy(flip(comparing(my snd)), ¬
                map(fanArrow(my head, my |length|), ¬
                    groupBy(my eq, sort(characters of s)))))
        end |λ|
    end script

    bindLR(readFileLR(fp), go)
end charCounts


-------------------------- TEST ---------------------------
on run
    set intColumns to 4

    either(identity, frequencyTabulation(intColumns), ¬
        charCounts("~/Code/charCount/readme.txt"))

end run


------------------------- DISPLAY -------------------------

-- frequencyTabulation :: Int -> [(Char, Int)] -> String
on frequencyTabulation(intCols)
    script
        on |λ|(xs)
            set w to length of (snd(item 1 of xs) as string)
            script go
                on |λ|(x)
                    justifyRight(5, " ", showChar(fst(x))) & ¬
                        " -> " & justifyRight(w, " ", snd(x) as string)
                end |λ|
            end script
            showColumns(intCols, map(go, xs))
        end |λ|
    end script
end frequencyTabulation


-------------------- GENERIC FUNCTIONS --------------------

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
    -- Constructor for a pair of values, possibly of two different types.
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
    if missing value is not |Left| of m then
        m
    else
        mReturn(mf)'s |λ|(|Right| of m)
    end if
end bindLR


-- chunksOf :: Int -> [a] -> [[a]]
on chunksOf(n, xs)
    set lng to length of xs
    script go
        on |λ|(a, i)
            set x to (i + n) - 1
            if x ≥ lng then
                a & {items i thru -1 of xs}
            else
                a & {items i thru x of xs}
            end if
        end |λ|
    end script
    foldl(go, {}, enumFromThenTo(1, 1 + n, lng))
end chunksOf


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


-- either :: (a -> c) -> (b -> c) -> Either a b -> c
on either(lf, rf, e)
    if missing value is |Left| of e then
        tell mReturn(rf) to |λ|(|Right| of e)
    else
        tell mReturn(lf) to |λ|(|Left| of e)
    end if
end either


-- enumFromThenTo :: Int -> Int -> Int -> [Int]
on enumFromThenTo(x1, x2, y)
    set xs to {}
    set gap to x2 - x1
    set d to max(1, abs(gap)) * (signum(gap))
    repeat with i from x1 to y by d
        set end of xs to i
    end repeat
    return xs
end enumFromThenTo


-- eq (==) :: Eq a => a -> a -> Bool
on eq(a, b)
    a = b
end eq


-- Compose a function from a simple value to a tuple of
-- the separate outputs of two different functions
-- fanArrow (&&&) :: (a -> b) -> (a -> c) -> (a -> (b, c))
on fanArrow(f, g)
    script
        on |λ|(x)
            Tuple(mReturn(f)'s |λ|(x), mReturn(g)'s |λ|(x))
        end |λ|
    end script
end fanArrow


-- flip :: (a -> b -> c) -> b -> a -> c
on flip(f)
    script
        property g : mReturn(f)
        on |λ|(x, y)
            g's |λ|(y, x)
        end |λ|
    end script
end flip


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


-- head :: [a] -> a
on head(xs)
    if xs = {} then
        missing value
    else
        item 1 of xs
    end if
end head


-- identity :: a -> a
on identity(x)
    -- The argument unchanged.
    x
end identity


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


-- max :: Ord a => a -> a -> a
on max(x, y)
    if x > y then
        x
    else
        y
    end if
end max

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


-- readFileLR :: FilePath -> Either String IO String
on readFileLR(strPath)
    set ca to current application
    set e to reference
    set {s, e} to (ca's NSString's ¬
        stringWithContentsOfFile:((ca's NSString's ¬
            stringWithString:strPath)'s ¬
            stringByStandardizingPath) ¬
            encoding:(ca's NSUTF8StringEncoding) |error|:(e))
    if s is missing value then
        |Left|((localizedDescription of e) as string)
    else
        |Right|(s as string)
    end if
end readFileLR


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


-- showChar :: Char -> String
on showChar(c)
    if space is c then
        "SPACE"
    else if tab is c then
        "TAB"
    else if linefeed is c then
        "LF"
    else
        c
    end if
end showChar


-- showColumns :: Int -> [String] -> String
on showColumns(n, xs)
    set w to maximum(map(my |length|, xs))
    set m to (length of xs) div n
    unlines(map(my unwords, ¬
        transpose(chunksOf(m, xs))))
end showColumns


-- signum :: Num -> Num
on signum(x)
    if x < 0 then
        -1
    else if x = 0 then
        0
    else
        1
    end if
end signum

-- snd :: (a, b) -> b
on snd(tpl)
    if class of tpl is record then
        |2| of tpl
    else
        item 2 of tpl
    end if
end snd


-- sort :: Ord a => [a] -> [a]
on sort(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort


-- Enough for small scale sorts.
-- Use instead sortOn (Ord b => (a -> b) -> [a] -> [a])
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


-- transpose :: [[String]] -> [[String]]
on transpose(rows)
    script cols
        on |λ|(_, iCol)
            script cell
                on |λ|(row)
                    if iCol > length of row then
                        ""
                    else
                        item iCol of row
                    end if
                end |λ|
            end script
            concatMap(cell, rows)
        end |λ|
    end script
    map(cols, item 1 of rows)
end transpose


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


-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords
