use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


------------------------ WORD WHEEL ----------------------

-- wordWheelMatches :: NSString -> [String] -> String -> String
on wordWheelMatches(lexicon, wordWheelRows)

    set wheelGroups to group(sort(characters of ¬
        concat(wordWheelRows)))

    script isWheelWord
        on |λ|(w)
            script available
                on |λ|(a, b)
                    length of a ≤ length of b
                end |λ|
            end script

            script used
                on |λ|(grp)
                    w contains item 1 of grp
                end |λ|
            end script

            all(my identity, ¬
                zipWith(available, ¬
                    group(sort(characters of w)), ¬
                    filter(used, wheelGroups)))
        end |λ|
    end script

    set matches to filter(isWheelWord, ¬
        filteredLines(wordWheelPreFilter(wordWheelRows), lexicon))

    (length of matches as text) & " matches:" & ¬
        linefeed & linefeed & unlines(matches)
end wordWheelMatches


-- wordWheelPreFilter :: [String] -> String
on wordWheelPreFilter(wordWheelRows)
    set pivot to item 2 of item 2 of wordWheelRows
    set charSet to nub(concat(wordWheelRows))

    "(2 < self.length) and (self contains '" & pivot & "') " & ¬
        "and not (self matches '^.*[^" & charSet & "].*$') "
end wordWheelPreFilter


--------------------------- TEST -------------------------
on run
    set fpWordList to scriptFolder() & "unixdict.txt"
    if doesFileExist(fpWordList) then

        wordWheelMatches(readFile(fpWordList), ¬
            {"nde", "okg", "elw"})

    else
        display dialog "Word list not found in script folder:" & ¬
            linefeed & tab & fpWordList
    end if
end run



----------- GENERIC :: FILTERED LINES FROM FILE ----------

-- doesFileExist :: FilePath -> IO Bool
on doesFileExist(strPath)
    set ca to current application
    set oPath to (ca's NSString's stringWithString:strPath)'s ¬
        stringByStandardizingPath
    set {bln, int} to (ca's NSFileManager's defaultManager's ¬
        fileExistsAtPath:oPath isDirectory:(reference))
    bln and (int ≠ 1)
end doesFileExist


-- filteredLines :: String -> NString -> [a]
on filteredLines(predicateString, s)
    -- A list of lines filtered by an NSPredicate string
    set ca to current application

    set predicate to ca's NSPredicate's predicateWithFormat:predicateString
    set array to ca's NSArray's ¬
        arrayWithArray:(s's componentsSeparatedByString:(linefeed))

    (array's filteredArrayUsingPredicate:(predicate)) as list
end filteredLines


-- readFile :: FilePath -> IO NSString
on readFile(strPath)
    set ca to current application
    set e to reference
    set {s, e} to (ca's NSString's ¬
        stringWithContentsOfFile:((ca's NSString's ¬
            stringWithString:strPath)'s ¬
            stringByStandardizingPath) ¬
            encoding:(ca's NSUTF8StringEncoding) |error|:(e))
    if missing value is e then
        s
    else
        (localizedDescription of e) as string
    end if
end readFile


-- scriptFolder :: () -> IO FilePath
on scriptFolder()
    -- The path of the folder containing this script
    try
        tell application "Finder" to ¬
            POSIX path of ((container of (path to me)) as alias)
    on error
        display dialog "Script file must be saved"
    end try
end scriptFolder


------------------------- GENERIC ------------------------

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    -- Constructor for a pair of values,
    -- possibly of two different types.
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple


-- all :: (a -> Bool) -> [a] -> Bool
on all(p, xs)
    -- True if p holds for every value in xs
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if not |λ|(item i of xs, i, xs) then return false
        end repeat
        true
    end tell
end all


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


-- eq (==) :: Eq a => a -> a -> Bool
on eq(a, b)
    a = b
end eq


-- filter :: (a -> Bool) -> [a] -> [a]
on filter(p, xs)
    tell mReturn(p)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        if {text, string} contains class of xs then
            lst as text
        else
            lst
        end if
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


-- group :: Eq a => [a] -> [[a]]
on group(xs)
    script eq
        on |λ|(a, b)
            a = b
        end |λ|
    end script

    groupBy(eq, xs)
end group


-- groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
on groupBy(f, xs)
    -- Typical usage: groupBy(on(eq, f), xs)
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


-- identity :: a -> a
on identity(x)
    -- The argument unchanged.
    x
end identity


-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|


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
    -- 2nd class handler function
    -- lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


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


-- nub :: [a] -> [a]
on nub(xs)
    nubBy(eq, xs)
end nub


-- nubBy :: (a -> a -> Bool) -> [a] -> [a]
on nubBy(f, xs)
    set g to mReturn(f)'s |λ|

    script notEq
        property fEq : g
        on |λ|(a)
            script
                on |λ|(b)
                    not fEq(a, b)
                end |λ|
            end script
        end |λ|
    end script

    script go
        on |λ|(xs)
            if (length of xs) > 1 then
                set x to item 1 of xs
                {x} & go's |λ|(filter(notEq's |λ|(x), items 2 thru -1 of xs))
            else
                xs
            end if
        end |λ|
    end script

    go's |λ|(xs)
end nubBy



-- sort :: Ord a => [a] -> [a]
on sort(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort


-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    if 0 < n then
        items 1 thru min(n, length of xs) of xs
    else
        {}
    end if
end take


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set s to xs as text
    set my text item delimiters to dlm
    s
end unlines


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
