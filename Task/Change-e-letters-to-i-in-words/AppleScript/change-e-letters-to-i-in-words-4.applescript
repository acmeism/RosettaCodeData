use framework "Foundation"


----- DICTIONARY WORDS TWINNED BY (E -> I) REPLACEMENT ---

-- ieTwins :: String -> [(String, String)]
on ieTwins(s)
    -- Pairs of dictionary words in s which
    -- are twinned by (e -> i) replacement

    set ca to current application

    set longWords to filteredLines("5 < length", s)
    set eWords to longWords's ¬
        filteredArrayUsingPredicate:(containsString("e"))

    set lexicon to ca's NSSet's ¬
        setWithArray:(longWords's ¬
            filteredArrayUsingPredicate:(containsString("i")))

    set possibles to (allReplaced("e", "i", ¬
        (eWords's componentsJoinedByString:(linefeed))))'s ¬
        componentsSeparatedByString:(linefeed)
    set possibleSet to ca's NSMutableSet's setWithArray:(possibles)
    possibleSet's intersectSet:(lexicon)


    -- Dictionary of possible words and their sources
    set dict to dictFromZip(possibles, eWords)

    -- Listing of candidate words which are found in the dictionary
    -- (twinned with their sources)
    script pair
        on |λ|(k)
            {(dict's objectForKey:(k)) as string, k}
        end |λ|
    end script
    map(pair, ((possibleSet's allObjects())'s ¬
        sortedArrayUsingSelector:"compare:") as list)
end ieTwins


--------------------------- TEST -------------------------
on run
    script go
        on |λ|(ei)
            set {e, i} to ei

            i & " <- " & e
        end |λ|
    end script

    unlines(map(go, ¬
        ieTwins(readFile("~/Desktop/unixdict.txt"))))
end run


------------------------- GENERIC ------------------------

-- allRplaced :: String -> String -> NSString -> NSString
on allReplaced(needle, replacement, haystack)
    haystack's stringByReplacingOccurrencesOfString:(needle) ¬
        withString:(replacement)
end allReplaced


-- containsString :: String -> NSPredicate
on containsString(s)
    tell current application
        its (NSPredicate's ¬
            predicateWithFormat:("self contains '" & s & "'"))
    end tell
end containsString


-- dictFromZip :: NSArray -> NSArray -> NSDictionary
on dictFromZip(ks, vs)
    tell current application
        its (NSDictionary's ¬
            dictionaryWithObjects:vs forKeys:ks)
    end tell
end dictFromZip


-- filteredLines :: String -> NSString -> [a]
on filteredLines(predicateString, s)
    -- A list of lines filtered by an NSPredicate string
    tell current application
        set predicate to its (NSPredicate's ¬
            predicateWithFormat:predicateString)
        set array to its (NSArray's ¬
            arrayWithArray:(s's componentsSeparatedByString:(linefeed)))
    end tell

    (array's filteredArrayUsingPredicate:(predicate))
end filteredLines


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
