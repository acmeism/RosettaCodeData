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

on longestDerangedAnagrams(listOfWords)
    script o
        property wordList : listOfWords
        property groupingTexts : wordList's items
        property derangementLength : 0
        property output : {}

        -- Test for any deranged pairs amongst the words of an anagram group.
        on testPairs(a, b)
            set anagramGroup to my wordList's items a thru b
            set groupSize to b - a + 1
            set wordLength to (count beginning of anagramGroup)
            repeat with i from 1 to (groupSize - 1)
                set w1 to anagramGroup's item i
                repeat with j from (i + 1) to groupSize
                    set w2 to anagramGroup's item j
                    set areDeranged to true
                    repeat with c from 1 to wordLength
                        if (w1's character c = w2's character c) then
                            set areDeranged to false
                            exit repeat
                        end if
                    end repeat
                    -- Append any deranged pairs found to the output and note the words' length.
                    if (areDeranged) then
                        set end of output to {w1, w2}
                        set derangementLength to wordLength
                    end if
                end repeat
            end repeat
        end testPairs

        -- Custom comparison handler for the sort. Text a should go after text b if
        -- it's the same length and has a greater lexical value or it's shorter than b.
        -- (The lexical sort direction isn't really relevant. It's just to group equal texts.)
        on isGreater(a, b)
            set aLen to a's length
            set bLen to b's length
            if (aLen = bLen) then return (a > b) -- or (b < a)!
            return (aLen < bLen)
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
        -- Sort the list descending by text length and ascending (say) by value
        -- within lengths. Echo the moves in the original word list.
        tell sorter to sort(o's groupingTexts, 1, wordCount, {comparer:o, slave:{o's wordList}})

        -- Work through the runs of grouping texts, starting with the longest texts.
        set i to 1
        set currentText to beginning of o's groupingTexts
        repeat with j from 2 to (wordCount)
            set thisText to o's groupingTexts's item j
            if (thisText is not currentText) then
                if (j - i > 1) then tell o to testPairs(i, j - 1)
                set currentText to thisText
                set i to j
            end if
            -- Stop on reaching a text that's shorter than any derangement(s) found.
            if ((count thisText) < o's derangementLength) then exit repeat
        end repeat
        if (j > i) then tell o to testPairs(i, j)
    end ignoring

    return o's output
end longestDerangedAnagrams

local wordFile, wordList
set wordFile to ((path to desktop as text) & "www.rosettacode.org:unixdict.txt") as «class furl»
set wordList to paragraphs of (read wordFile as «class utf8»)
return longestDerangedAnagrams(wordList)
