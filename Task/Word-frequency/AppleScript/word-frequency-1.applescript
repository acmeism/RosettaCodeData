(*
    For simplicity here, words are considered to be uninterrupted sequences of letters and/or digits.
    The set text is too messy to warrant faffing around with anything more sophisticated.
    The first letter in each word is upper-cased and the rest lower-cased for case equivalence and presentation.
    Where more than n words qualify for the top n or fewer places, all are included in the result.
*)

use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on wordFrequency(filePath, n)
    set |⌘| to current application

    -- Get the text and "capitalize" it (lower-case except for the first letters in words).
    set theText to |⌘|'s class "NSString"'s stringWithContentsOfFile:(filePath) usedEncoding:(missing value) |error|:(missing value)
    set theText to theText's capitalizedStringWithLocale:(|⌘|'s class "NSLocale"'s currentLocale()) -- Yosemite compatible.
    -- Split it at the non-word characters.
    set nonWordCharacters to |⌘|'s class "NSCharacterSet"'s alphanumericCharacterSet()'s invertedSet()
    set theWords to theText's componentsSeparatedByCharactersInSet:(nonWordCharacters)

    -- Use a counted set to count the individual words' occurrences.
    set countedSet to |⌘|'s class "NSCountedSet"'s alloc()'s initWithArray:(theWords)

    -- Build a list of word/frequency records, excluding any empty strings left over from the splitting above.
    set mutableSet to |⌘|'s class "NSMutableSet"'s setWithSet:(countedSet)
    tell mutableSet to removeObject:("")
    script o
        property discreteWords : mutableSet's allObjects() as list
        property wordsAndFrequencies : {}
    end script
    set discreteWordCount to (count o's discreteWords)
    repeat with i from 1 to discreteWordCount
        set thisWord to item i of o's discreteWords
        set end of o's wordsAndFrequencies to {thisWord:thisWord, frequency:(countedSet's countForObject:(thisWord)) as integer}
    end repeat

    -- Convert to NSMutableArray, reverse-sort the result on the frequencies, and convert back to list.
    set wordsAndFrequencies to |⌘|'s class "NSMutableArray"'s arrayWithArray:(o's wordsAndFrequencies)
    set descendingByFrequency to |⌘|'s class "NSSortDescriptor"'s sortDescriptorWithKey:("frequency") ascending:(false)
    tell wordsAndFrequencies to sortUsingDescriptors:({descendingByFrequency})
    set o's wordsAndFrequencies to wordsAndFrequencies as list

    if (discreteWordCount > n) then
        -- If there are more than n records, check for any immediately following the nth which may have the same frequency as it.
        set nthHighestFrequency to frequency of item n of o's wordsAndFrequencies
        set qualifierCount to n
        repeat with i from (n + 1) to discreteWordCount
            if (frequency of item i of o's wordsAndFrequencies = nthHighestFrequency) then
                set qualifierCount to i
            else
                exit repeat
            end if
        end repeat
    else
        -- Otherwise reduce n to the actual number of discrete words.
        set n to discreteWordCount
        set qualifierCount to discreteWordCount
    end if

    -- Compose a text report from the qualifying words and frequencies.
    if (qualifierCount = n) then
        set output to {"The " & n & " most frequently occurring words in the file are:"}
    else
        set output to {(qualifierCount as text) & " words share the " & ((n as text) & " highest frequencies in the file:")}
    end if
    repeat with i from 1 to qualifierCount
        set {thisWord:thisWord, frequency:frequency} to item i of o's wordsAndFrequencies
        set end of output to thisWord & ":      " & (tab & frequency)
    end repeat
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end wordFrequency

-- Test code:
set filePath to POSIX path of ((path to desktop as text) & "www.rosettacode.org:Word frequency:135-0.txt")
set n to 10
return wordFrequency(filePath, n)
