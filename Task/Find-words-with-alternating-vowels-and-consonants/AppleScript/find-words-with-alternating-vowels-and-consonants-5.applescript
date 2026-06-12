use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


------------ ALTERNATING VOWELS AND CONSONANTS -----------

-- alternatingWordQuery :: String -> String
on alternatingWordQuery(vowels)
    set regex to "^.*([" & vowels & "]{2}|[^" & vowels & "]{2}).*$"

    "(9 < self.length) and not (self matches '" & regex & "')"
end alternatingWordQuery


-- matchingWords :: NSString -> String -> String
on matchingWords(lexicon)
    script
        on |λ|(vowels)
            set query to alternatingWordQuery(vowels)

            set matches to filteredLines(query, lexicon)
            set intMatches to length of matches

            ("Assuming " & vowels & " – " & intMatches as text) & ¬
                " matches:" & linefeed & linefeed & ¬
                inColumns(4, matches)
        end |λ|
    end script
end matchingWords


--------------------------- TEST -------------------------
on run
    set fpWordList to scriptFolder() & "unixdict.txt"
    if doesFileExist(fpWordList) then

        intercalate(linefeed & linefeed, ¬
            map(matchingWords(readFile(fpWordList)), ¬
                {"aeiou", "aeiouy"}))
    else
        display dialog "Word list not found in this script's folder:" & ¬
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


-- filteredLines :: String -> NSString -> [a]
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


-------------- GENERIC :: COLUMNAR FORMATTING ------------

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    -- Constructor for a pair of values,
    -- possibly of two different types.
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple


-- chunksOf :: Int -> [a] -> [[a]]
on chunksOf(k, xs)
    script
        on go(ys)
            set ab to splitAt(k, ys)
            set a to |1| of ab
            if {} ≠ a then
                {a} & go(|2| of ab)
            else
                a
            end if
        end go
    end script
    result's go(xs)
end chunksOf


-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    if {text, string} contains class of xs then
        acc as text
    else
        acc
    end if
end concatMap


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


-- inColumns :: Int -> [String] -> String
on inColumns(n, xs)
    -- The strings in xs displayed in n columns
    -- of equal width.
    set widest to maximum(map(my |length|, xs))

    unlines(map(my unwords, chunksOf(n, ¬
        map(justifyLeft(widest, space), xs))))
end inColumns


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


-- justifyLeft :: Int -> Char -> String -> String
on justifyLeft(n, cFiller)
    script
        on |λ|(s)
            if n > length of s then
                text 1 thru n of (s & replicate(n, cFiller))
            else
                s
            end if
        end |λ|
    end script
end justifyLeft


-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|


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


-- replicate :: Int -> String -> String
on replicate(n, s)
    -- Egyptian multiplication - progressively doubling a list,
    -- appending stages of doubling to an accumulator where needed
    -- for binary assembly of a target length
    script p
        on |λ|({n})
            n ≤ 1
        end |λ|
    end script

    script f
        on |λ|({n, dbl, out})
            if (n mod 2) > 0 then
                set d to out & dbl
            else
                set d to out
            end if
            {n div 2, dbl & dbl, d}
        end |λ|
    end script

    set xs to |until|(p, f, {n, s, ""})
    item 2 of xs & item 3 of xs
end replicate


-- splitAt :: Int -> [a] -> ([a], [a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            Tuple(items 1 thru n of xs as text, ¬
                items (n + 1) thru -1 of xs as text)
        else
            Tuple(items 1 thru n of xs, items (n + 1) thru -1 of xs)
        end if
    else
        if n < 1 then
            Tuple({}, xs)
        else
            Tuple(xs, {})
        end if
    end if
end splitAt


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


-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set v to x
    set mp to mReturn(p)
    set mf to mReturn(f)
    repeat until mp's |λ|(v)
        set v to mf's |λ|(v)
    end repeat
    v
end |until|


-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords
