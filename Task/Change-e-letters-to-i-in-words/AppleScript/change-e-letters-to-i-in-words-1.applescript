use AppleScript version "2.3.1" -- Mac OS X 10.9 (Mavericks) or later.
use sorter : script "Insertion sort" -- <https://rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#AppleScript>
use scripting additions

on binarySearch(v, theList, l, r)
    script o
        property lst : theList
    end script

    repeat until (l = r)
        set m to (l + r) div 2
        if (o's lst's item m < v) then
            set l to m + 1
        else
            set r to m
        end if
    end repeat

    if (o's lst's item l = v) then return l
    return 0
end binarySearch

on replace(a, b, txt)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to a
    set txt to txt's text items
    set AppleScript's text item delimiters to b
    set txt to txt as text
    set AppleScript's text item delimiters to astid
    return txt
end replace

on task(minWordLength)
    set dictPath to (path to desktop as text) & "www.rosettacode.org:unixdict.txt"
    script o
        property wordList : paragraphs of (read file dictPath as «class utf8»)
        property iWords : {}
        property output : {}
    end script

    set wordCount to (count o's wordList)
    ignoring case
        tell sorter to sort(o's wordList, 1, wordCount) -- Not actually needed with unixdict.txt.

        set iWordCount to 0
        repeat with i from wordCount to 1 by -1
            set thisWord to o's wordList's item i
            if ((count thisWord) < minWordLength) then
            else if ((thisWord contains "e") and (iWordCount > 0)) then
                set changedWord to replace("e", "i", thisWord)
                if (binarySearch(changedWord, o's iWords, 1, iWordCount) > 0) then
                    set beginning of o's output to {thisWord, changedWord}
                end if
            else if (thisWord contains "i") then
                set beginning of o's iWords to thisWord
                set iWordCount to iWordCount + 1
            end if
        end repeat
    end ignoring

    return o's output
end task

task(6)
