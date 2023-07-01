use AppleScript version "2.3.1" -- OS X 10.9 (Mavericks) or later
use sorter : script ¬
    "Custom Iterative Ternary Merge Sort" --<www.macscripter.net/t/timsort-and-nigsort/71383/3>

-- Sort customiser.
script descendingByLengthThenAscendingLexicographically
    on isGreater(a, b)
        set lenA to a's length
        set lenB to b's length
        if (lenA = lenB) then return (a > b)
        return (lenB > lenA)
    end isGreater
end script

set listOfText to words of "now is the time for all good men to come to the aid of the party"
tell sorter to ¬
    sort(listOfText, 1, -1, {comparer:descendingByLengthThenAscendingLexicographically})
return listOfText
