use AppleScript version "2.3.1" -- OS X 10.9 (Mavericks) or later
use sorter : script ¬
    "Custom Iterative Ternary Merge Sort" --<www.macscripter.net/t/timsort-and-nigsort/71383/3>
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

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on alternades(inputList, subsPerAlternade, minAlternadeLen, outputType)
    script o
        property wordList : inputList's items
        property searchRanges : {}
        property output : {}

        -- Custom comparison handler for the sort.
        on isGreater(a, b)
            set lenA to a's length
            set lenB to b's length
            if (lenA = lenB) then return (a > b)
            return (lenA > lenB)
        end isGreater

        on finish()
            if (outputType is text) then set output to join(output, linefeed)
            return output
        end finish
    end script

    set wordCount to (count o's wordList)
    if (wordCount ≤ subsPerAlternade) then return o's finish()
    -- Sort the word list ascending by length, lexically within lengths.
    tell sorter to sort(o's wordList, 1, wordCount, {comparer:o})
    -- Deduce the maximum possible "subword" length from the length of the longest word.
    set maxWordLen to o's wordList's end's length
    if (maxWordLen < minAlternadeLen) then return o's finish()
    set maxSubLen to (maxWordLen + subsPerAlternade - 1) div subsPerAlternade
    -- Give the searchRanges list that many slots.
    repeat maxSubLen times
        set end of o's searchRanges to missing value
    end repeat
    -- For each word length in wordlist that's suitable for a subword, set the same-numbered slot in
    -- searchRanges to the range indices of the wordList range covering the words of that length.
    -- Also find the index in wordList of the first word whose length ≥ minAlternadeLen.
    set minSubLen to minAlternadeLen div subsPerAlternade
    set minAltLenStart to 1
    set i to 1
    set currentLength to o's wordList's beginning's length
    repeat with j from 2 to wordCount
        set wordLen to o's wordList's item j's length
        if (wordLen > currentLength) then
            if ((currentLength ≥ minSubLen) and (currentLength ≤ maxSubLen)) then
                set o's searchRanges's item currentLength to {i, j - 1}
                if (wordLen ≥ minAlternadeLen) then
                    if (minAltLenStart = 1) then
                        set minAltLenStart to j
                    else if (wordLen > maxSubLen) then
                        exit repeat
                    end if
                end if
            end if
            set i to j
            set currentLength to wordLen
        end if
    end repeat

    -- Extract subtexts from words having minAlternadeLen or more characters and see if they match
    -- words from the same-length ranges in wordList. Append any hits to the output.
    if (outputType is text) then set end of o's output to ""
	repeat with w from minAltLenStart to wordCount -- Per long-enough word.
        set thisWord to o's wordList's item w
        set wordLen to thisWord's length
        set foundSubs to {}
        repeat with s from 1 to subsPerAlternade -- Per subword.
            set sub to thisWord's character s
            repeat with c from (s + subsPerAlternade) to wordLen by subsPerAlternade -- Per chr.
                set sub to sub & thisWord's character c
            end repeat
            set range to o's searchRanges's item (sub's length)
            if ((range = missing value) or ¬
                (binarySearch(sub, o's wordList, range's beginning, range's end) = 0)) then ¬
                exit repeat
            set end of foundSubs to sub
        end repeat
        if ((count foundSubs) = subsPerAlternade) then
            if (outputType is text) then
                set beginning of foundSubs to thisWord & ":"
                set end of o's output to join(foundSubs, tab & tab)
            else
                set end of o's output to {alternade:thisWord, subs:foundSubs}
            end if
        end if
    end repeat

    return o's finish()
end alternades

-- Task code:
local wordFile, wordList
set wordFile to ((path to desktop as text) & "www.rosettacode.org:unixdict.txt") as «class furl»
set wordList to words of (read wordFile as «class utf8»)
-- Return two-word alternades of 6 or more characters. Result as text (as opposed to list).
return alternades(wordList, 2, 6, text)
