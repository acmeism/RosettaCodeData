on LCS(a, b)
    -- Identify the shorter string. The longest common substring won't be longer than it!
    set lengthA to a's length
    set lengthB to b's length
    if (lengthA < lengthB) then
        set {shorterString, shorterLength, longerString} to {a, lengthA, b}
    else
        set {shorterString, shorterLength, longerString} to {b, lengthB, a}
    end if

    set longestMatches to {}
    set longestMatchLength to 0
    -- Find the longest matching substring starting at each character in the shorter string.
    repeat with i from 1 to shorterLength
        repeat with j from shorterLength to i by -1
            set thisSubstring to text i thru j of shorterString
            if (longerString contains thisSubstring) then
                -- Match found. If it's longer than the previously found match, or a new string of the same length, remember it.
                set matchLength to j - i + 1
                if (matchLength > longestMatchLength) then
                    set longestMatches to {thisSubstring}
                    set longestMatchLength to matchLength
                else if ((matchLength = longestMatchLength) and (thisSubstring is not in longestMatches)) then
                    set end of longestMatches to thisSubstring
                end if
                -- Don't bother with the match's own substrings.
                exit repeat
            end if
        end repeat
    end repeat

    return longestMatches
end LCS
