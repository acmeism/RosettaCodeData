use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on binarySearch(v, theList, l, r)
    script o
        property lst : theList
    end script

    repeat until (l = r)
        set m to (l + r) div 2
        if (item m of o's lst < v) then
            set l to m + 1
        else
            set r to m
        end if
    end repeat

    if (item l of o's lst is v) then return l
    return 0
end binarySearch

on task(minWordLength)
    set |⌘| to current application
    -- Read the unixdict.txt file.
    set dictPath to (POSIX path of (path to desktop)) & "www.rosettacode.org/unixdict.txt"
    set dictText to |⌘|'s class "NSString"'s stringWithContentsOfFile:(dictPath) ¬
        usedEncoding:(missing value) |error|:(missing value)
    -- Extract its words, which are known to be one per line.
    set newlineSet to |⌘|'s class "NSCharacterSet"'s newlineCharacterSet()
    set wordArray to dictText's componentsSeparatedByCharactersInSet:(newlineSet)
    -- Case-insensitively extract any words containing "e" whose length is at least minWordLength.
    set filter to |⌘|'s class "NSPredicate"'s ¬
        predicateWithFormat:("(self MATCHES '.{" & minWordLength & ",}+') && (self CONTAINS[c] 'e')")
    set eWords to wordArray's filteredArrayUsingPredicate:(filter)
    -- Case-insensitively extract and sort any words containing "i" but not "e" whose length is at least minWordLength.
    set filter to |⌘|'s class "NSPredicate"'s ¬
        predicateWithFormat:("(self MATCHES '.{" & minWordLength & ",}+') && (self CONTAINS[c] 'i') && !(self CONTAINS[c] 'e')")
    set iWords to (wordArray's filteredArrayUsingPredicate:(filter))'s sortedArrayUsingSelector:("localizedStandardCompare:")
    -- Replace the "e"s in the "e" words with (lower-case) "i"s.
    set changedWords to ((eWords's componentsJoinedByString:(linefeed))'s ¬
        lowercaseString()'s stringByReplacingOccurrencesOfString:("e") withString:("i"))'s ¬
        componentsSeparatedByCharactersInSet:(newlineSet)

    -- Switch to vanilla to check the changed words.
    script o
        property eWordList : eWords as list
        property iWordList : iWords as list
        property changedWordList : changedWords as list
        property output : {}
    end script
    -- Case-insensitively (by default), search the "i" word list for each word in the changed word list.
    -- Where found, use the original-case version from the "i" word list.
    set iWordCount to (count o's iWordList)
    repeat with i from 1 to (count o's changedWordList)
        set matchIndex to binarySearch(item i of o's changedWordList, o's iWordList, 1, iWordCount)
        if (matchIndex > 0) then set end of o's output to {item i of o's eWordList, item matchIndex of o's iWordList}
    end repeat

    return o's output
end task

task(6)
