use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


---------------------- TEST OF CLAIMS --------------------
on run
    set fpWordList to scriptFolder() & "unixdict.txt"
    if doesFileExist(fpWordList) then

        set patterns to {"[^c]ie", "[^c]ei", "cei", "cie"}
        set counts to ap(map(matchCount, patterns), ¬
            {readFile(fpWordList)})

        script test
            on |λ|(kvs)
                set {common, rare} to kvs
                set {ck, cv} to common
                set {rk, rv} to rare

                set ratio to roundTo(2, cv / rv)
                if ratio > 2 then
                    set verdict to "plausible"
                else
                    set verdict to "unsupported"
                end if

                unwords({ck, ">", rk, "->", cv, "/", rv, ¬
                    "=", ratio, "::", verdict})
            end |λ|
        end script

        unlines(map(test, chunksOf(2, zip(patterns, counts))))
    else
        display dialog "Word list not found in this script's folder:" & ¬
            linefeed & tab & fpWordList
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


-- chunksOf :: Int -> [a] -> [[a]]
on chunksOf(k, xs)
    script
        on go(ys)
            set ab to splitAt(k, ys)
            set a to item 1 of ab
            if {} ≠ a then
                {a} & go(item 2 of ab)
            else
                a
            end if
        end go
    end script
    result's go(xs)
end chunksOf


-- doesFileExist :: FilePath -> IO Bool
on doesFileExist(strPath)
    set ca to current application
    set oPath to (ca's NSString's stringWithString:strPath)'s ¬
        stringByStandardizingPath
    set {bln, int} to (ca's NSFileManager's defaultManager's ¬
        fileExistsAtPath:oPath isDirectory:(reference))
    bln and (int ≠ 1)
end doesFileExist


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


-- roundTo :: Int -> Float -> Float
on roundTo(n, x)
    set d to 10 ^ n
    (round (x * d)) / d
end roundTo


-- scriptFolder :: () -> IO FilePath
on scriptFolder()
    -- The path of the folder containing this script
    tell application "Finder" to ¬
        POSIX path of ((container of (path to me)) as alias)
end scriptFolder


-- splitAt :: Int -> [a] -> ([a], [a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            {items 1 thru n of xs as text, ¬
                items (n + 1) thru -1 of xs as text}
        else
            {items 1 thru n of xs, items (n + 1) thru -1 of xs}
        end if
    else
        if n < 1 then
            {{}, xs}
        else
            {xs, {}}
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
