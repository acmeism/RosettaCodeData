use AppleScript version "2.3.1" -- OS X 10.9 (Mavericks) or later.
use sorter : script ¬
    "Custom Iterative Ternary Merge Sort" -- <www.macscripter.net/t/timsort-and-nigsort/71383/3>
use scripting additions

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on largestAnagramGroups(listOfWords)
    script o
        property wordList : listOfWords
        property groupingTexts : wordList's items
        property largestGroupSize : 0
        property largestGroupRanges : {}

        on judgeGroup(i, j)
            set groupSize to j - i + 1
            if (groupSize < largestGroupSize) then -- Most likely.
            else if (groupSize = largestGroupSize) then -- Next most likely.
                set end of largestGroupRanges to {i, j}
            else -- Largest group so far.
                set largestGroupRanges to {{i, j}}
                set largestGroupSize to groupSize
            end if
        end judgeGroup

        on isGreater(a, b)
            return a's beginning > b's beginning
        end isGreater
    end script

    set wordCount to (count o's wordList)
    ignoring case
        -- Replace the words in the groupingTexts list with sorted-character versions.
        repeat with i from 1 to wordCount
            set chrs to o's groupingTexts's item i's characters
            tell sorter to sort(chrs, 1, -1, {})
            set o's groupingTexts's item i to join(chrs, "")
        end repeat
        -- Sort the list to group its contents and echo the moves in the original word list.
        tell sorter to sort(o's groupingTexts, 1, wordCount, {slave:{o's wordList}})

        -- Find the list range(s) of the longest run(s) of equal grouping texts.
        set i to 1
        set currentText to beginning of o's groupingTexts
        repeat with j from 2 to wordCount
            set thisText to o's groupingTexts's item j
            if (thisText is not currentText) then
                tell o to judgeGroup(i, j - 1)
                set currentText to thisText
                set i to j
            end if
        end repeat
        if (j > i) then tell o to judgeGroup(i, j)

        -- Extract the group(s) of words occupying the same range(s) in the original word list.
        set output to {}
        repeat with thisRange in o's largestGroupRanges
            set {i, j} to thisRange
            -- Add this group to the output.
            set thisGroup to o's wordList's items i thru j
            tell sorter to sort(thisGroup, 1, -1, {}) -- Not necessary with unixdict.txt. But hey.
            set end of output to thisGroup
        end repeat

        -- As a final flourish, sort the groups on their first items.
        tell sorter to sort(output, 1, -1, {comparer:o})
    end ignoring

    return output
end largestAnagramGroups

local wordFile, wordList
set wordFile to ((path to desktop as text) & "www.rosettacode.org:unixdict.txt") as «class furl»
set wordList to paragraphs of (read wordFile as «class utf8»)
return largestAnagramGroups(wordList)
