use AppleScript version "2.3.1" -- Mac OS X 10.9 (Mavericks) or later.
use sorter : script ¬
    "Custom Iterative Ternary Merge Sort" -- <www.macscripter.net/t/timsort-and-nigsort/71383/3>

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on sortLexicographically(integerList)
    set textList to paragraphs of join(integerList, linefeed)
    -- Sort textList, echoing the moves in integerList.
    considering hyphens but ignoring numeric strings
        tell sorter to sort(textList, 1, -1, {slave:{integerList}})
    end considering
end sortLexicographically

-- Test code:
local someIntegers
set someIntegers to {1, 2, -6, 3, 4, 5, -10, 6, 7, 8, 9, 10, 11, 12, 13, -2, -5, -1, -4, -3, 0}
sortLexicographically(someIntegers)
return someIntegers
