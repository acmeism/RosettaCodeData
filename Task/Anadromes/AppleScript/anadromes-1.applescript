use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on Anadromes(textFile, minLength)
    set |⌘| to current application
    -- Read the text from the file.
    set theText to |⌘|'s class "NSString"'s stringWithContentsOfFile:(textFile's POSIX path) ¬
        usedEncoding:(missing value) |error|:(missing value)
    -- Lose paragraphs (one word per paragraph) which have fewer than minLength characters.
    set theText to theText's stringByReplacingOccurrencesOfString:("(?m)^.{0," & minLength - 1 & "}\\R") withString:("") ¬
        options:(|⌘|'s NSRegularExpressionSearch) range:({0, theText's |length|()})
    -- Get the remaining paragraphs as an array.
    set wordArray to (theText's componentsSeparatedByCharactersInSet:(|⌘|'s class "NSCharacterSet"'s controlCharacterSet()))

    -- Derive a list of reversed words.
    script o
        property wordList : (wordArray) as list
    end script
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    repeat with i from 1 to (count o's wordList)
        set o's wordList's item i to (o's wordList's item i's characters's reverse) as text
    end repeat

    -- Get a list of words that are in both the original and reversed groups.
    set reversedWordSet to |⌘|'s class "NSSet"'s setWithArray:(o's wordList)
    set filter to |⌘|'s class "NSPredicate"'s predicateWithFormat_("self IN %@", reversedWordSet)
    set o's wordList to (wordArray's filteredArrayUsingPredicate:(filter)) as list

    -- Build the output line by line, omitting palindromes and already matched word pairs.
    set output to {}
    repeat with i from 1 to (count o's wordList)
        set thisWord to o's wordList's item i
        set o's wordList's item i to missing value
        set reversedWord to (thisWord's characters's reverse) as text
        if ({reversedWord} is in o's wordList) then set output's end to thisWord & " <--> " & reversedWord
    end repeat
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end Anadromes

return Anadromes(((path to desktop as text) & "www.rosettacode.org:words.txt") as «class furl», 7)
