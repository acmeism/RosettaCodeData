use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on task()
    set |⌘| to current application
    set dictPath to (POSIX path of (path to desktop)) & "unixdict.txt"
    set dictText to |⌘|'s class "NSString"'s stringWithContentsOfFile:(dictPath) ¬
        usedEncoding:(missing value) |error|:(missing value)
    set newlineSet to |⌘|'s class "NSCharacterSet"'s newlineCharacterSet()
    set wordArray to dictText's componentsSeparatedByCharactersInSet:(newlineSet)
    -- Lose words with fewer than 9 characters.
    set filter to |⌘|'s class "NSPredicate"'s predicateWithFormat:("self MATCHES '.{9,}+'")
    set relevantWords to wordArray's filteredArrayUsingPredicate:(filter)

    -- Creating the new words is most easily and efficiently done with core AppleScript.
    script o
        property wordList : relevantWords as list
        property newWords : {}
    end script
    repeat with i from 1 to ((count o's wordList) - 8)
        set newWord to character 1 of item i of o's wordList
        set j to (i - 1)
        repeat with k from 2 to 9
            set newWord to newWord & character k of item (j + k) of o's wordList
        end repeat
        set end of o's newWords to newWord
    end repeat

    -- But Foundation sets are good for filtering the results.
    set matches to |⌘|'s class "NSMutableOrderedSet"'s orderedSetWithArray:(o's newWords)
    tell matches to intersectSet:(|⌘|'s class "NSSet"'s setWithArray:(relevantWords))

    return (matches's array()) as list
end task

task()
