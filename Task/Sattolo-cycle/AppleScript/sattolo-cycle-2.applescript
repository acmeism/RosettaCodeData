on sattoloShuffle(theList) -- In-place shuffle.
    -- Script object to which list variables can "belong".
    script o
        property lst : theList as list -- Original list.
        property indices : my lst's items -- Shallow copy.
    end script

    -- Populate the copy with indices. (No need to bother with the first.)
    set listLength to (count o's lst)
    repeat with i from 2 to listLength
        set item i of o's indices to i
    end repeat
    -- Repeatedly lose the first item in the index list and select an index at random from what's left.
    repeat with i from 1 to listLength - 1
        set o's indices to rest of o's indices
        set j to some item of o's indices
        set temp to item i of o's lst
        set item i of o's lst to item j of o's lst
        set item j of o's lst to temp
    end repeat
    return -- Return nothing (ie. not the result of the last action above).
end sattoloShuffle

-- Task demo:
local output, astid, aList
set output to {}
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ", "
repeat with aList in {{}, {10}, {10, 20}, {10, 20, 30}, {11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22}}
    set end of output to "Before: {" & aList & "}"
    sattoloShuffle(aList)
    set end of output to "After:  {" & aList & "}"
end repeat
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
