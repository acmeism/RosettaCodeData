use AppleScript version "2.3.1" -- Mac OS 10.9 (Mavericks) or later — for these 'use' commands.
use sorter : script "Insertion sort" -- https://www.rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#AppleScript.
use scripting additions

on longestOrderedWords(wordList)
    script o
        property allWords : wordList
        property orderedWords : {}
    end script

    set longestWordLength to 0
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    ignoring case
        repeat with i from 1 to (count o's allWords)
            set thisWord to item i of o's allWords
            set thisWordLength to (count thisWord)
            if (thisWordLength ≥ longestWordLength) then
                set theseCharacters to thisWord's characters
                tell sorter to sort(theseCharacters, 1, -1)
                set sortedWord to theseCharacters as text
                if (sortedWord = thisWord) then
                    if (thisWordLength > longestWordLength) then
                        set o's orderedWords to {thisWord}
                        set longestWordLength to thisWordLength
                    else
                        set end of o's orderedWords to thisWord
                    end if
                end if
            end if
        end repeat
    end ignoring
    set AppleScript's text item delimiters to astid

    return (o's orderedWords)
end longestOrderedWords

-- Test code:
local wordList
set wordList to paragraphs of (read (((path to desktop as text) & "www.rosettacode.org:unixdict.txt") as alias) as «class utf8»)
-- ignoring white space, punctuation and diacriticals
return longestOrderedWords(wordList)
--- end ignoring
