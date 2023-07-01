use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


------ CASE AND ACCENT-INSENSITIVE FREQUENCIES OF A-Z ----

-- romanLetterFrequencies :: FilePath -> Maybe [(Char, Int)]
on romanLetterFrequencies(fp)
    if doesFileExist(fp) then
        set patterns to enumFromToChar("a", "z")

        set counts to ap(map(my matchCount, patterns), ¬
            {readFile(fp)'s ¬
                decomposedStringWithCanonicalMapping's ¬
                lowercaseString})

        sortBy(flip(comparing(my snd)))'s ¬
            |λ|(zip(patterns, counts))
    else
        missing value
    end if
end romanLetterFrequencies


--------------------------- TEST -------------------------
on run
    set fpText to scriptFolder() & "miserables.txt"

    set azFrequencies to romanLetterFrequencies(fpText)

    if missing value is not azFrequencies then
        script arrow
            on |λ|(kv)
                set {k, v} to kv
                unwords({k, "->", v})
            end |λ|
        end script
        unlines(map(arrow, azFrequencies))
    else
        display dialog "Text file not found in this script's folder:" & ¬
            linefeed & tab & fpText
    end if
end run


------------------------- GENERIC ------------------------

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    -- Constructor for a pair of values, possibly of two different types.
    {a, b}
end Tuple


-- ap (<*>) :: [(a -> b)] -> [a] -> [b]
on ap(fs, xs)
    -- e.g. [(*2),(/2), sqrt] <*> [1,2,3]
    -- -->  ap([dbl, hlf, root], [1, 2, 3])
    -- -->  [2,4,6,0.5,1,1.5,1,1.4142135623730951,1.7320508075688772]
    -- Each member of a list of functions applied to
    -- each of a list of arguments, deriving a list of new values
    set lst to {}
    repeat with f in fs
        tell mReturn(contents of f)
            repeat with x in xs
                set end of lst to |λ|(contents of x)
            end repeat
        end tell
    end repeat
    return lst
end ap


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


-- doesFileExist :: FilePath -> IO Bool
on doesFileExist(strPath)
    set ca to current application
    set oPath to (ca's NSString's stringWithString:strPath)'s ¬
        stringByStandardizingPath
    set {bln, int} to (ca's NSFileManager's defaultManager's ¬
        fileExistsAtPath:oPath isDirectory:(reference))
    bln and (int ≠ 1)
end doesFileExist


-- enumFromToChar :: Char -> Char -> [Char]
on enumFromToChar(m, n)
    set {intM, intN} to {id of m, id of n}
    if intM ≤ intN then
        set xs to {}
        repeat with i from intM to intN
            set end of xs to character id i
        end repeat
        return xs
    else
        {}
    end if
end enumFromToChar


-- flip :: (a -> b -> c) -> b -> a -> c
on flip(f)
    script
        property g : mReturn(f)
        on |λ|(x, y)
            g's |λ|(y, x)
        end |λ|
    end script
end flip


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


-- matchCount :: String -> NSString -> Int
on matchCount(regexString)
    -- A count of the matches for a regular expression
    -- in a given NSString
    script
        on |λ|(s)
            set ca to current application
            ((ca's NSRegularExpression's ¬
                regularExpressionWithPattern:regexString ¬
                    options:(ca's NSRegularExpressionAnchorsMatchLines) ¬
                    |error|:(missing value))'s ¬
                numberOfMatchesInString:s ¬
                    options:0 ¬
                    range:{location:0, |length|:s's |length|()}) as integer
        end |λ|
    end script
end matchCount


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
    {ys, zs}
end partition


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
    tell application "Finder" to ¬
        POSIX path of ((container of (path to me)) as alias)
end scriptFolder


-- snd :: (a, b) -> b
on snd(tpl)
    item 2 of tpl
end snd


-- sortBy :: (a -> a -> Ordering) -> [a] -> [a]
on sortBy(f)
    -- Enough for small scale sorts.
    -- The NSArray sort method in the Foundation library
    -- gives better permormance for longer lists.
    script go
        on |λ|(xs)
            if length of xs > 1 then
                set h to item 1 of xs
                set f to mReturn(f)
                script
                    on |λ|(x)
                        f's |λ|(x, h) ≤ 0
                    end |λ|
                end script
                set lessMore to partition(result, rest of xs)
                |λ|(item 1 of lessMore) & {h} & ¬
                    |λ|(item 2 of lessMore)
            else
                xs
            end if
        end |λ|
    end script
end sortBy


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


-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords


-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    zipWith(Tuple, xs, ys)
end zip


-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    if 1 > lng then
        return {}
    else
        tell mReturn(f)
            repeat with i from 1 to lng
                set end of lst to |λ|(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith
