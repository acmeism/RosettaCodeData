use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on abcWords(wordFile, theLetters)
    -- This NSString method used here guesses the word file's text encoding itself.
    set wordText to current application's class "NSString"'s stringWithContentsOfFile:(POSIX path of wordFile) ¬
        usedEncoding:(missing value) |error|:(missing value)

    -- Assuming one word per line, build a regex pattern to match words containing the specified letters in the given order.
    set theLetters to join(theLetters, "")
    set pattern to "(?mi)^"
    repeat with c from 1 to (count theLetters)
        set pattern to pattern & (("[^" & text c thru end of theLetters) & ("\\v]*+" & character c of theLetters))
    end repeat
    set pattern to pattern & ".*+$"

    set regexObj to current application's class "NSRegularExpression"'s ¬
        regularExpressionWithPattern:(pattern) options:(0) |error|:(missing value)

    set wordMatches to regexObj's matchesInString:(wordText) options:(0) range:({0, wordText's |length|()})
    set matchRanges to wordMatches's valueForKey:("range")

    set output to {}
    repeat with thisRange in matchRanges
        set end of output to (wordText's substringWithRange:(thisRange)) as text
    end repeat

    return output
end abcWords

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

return abcWords(((path to desktop as text) & "www.rosettacode.org:unixdict.txt") as alias, {"a", "b", "c"})
