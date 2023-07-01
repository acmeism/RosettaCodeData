on longestIncreasingSubsequences(aList)
    script o
        property inputList : aList
        property m : {} -- End indices of identified subsequences.
        property p : {} -- 'Predecessor' indices for each point in each subsequence.
        property subsequence : {} -- Reconstructed longest sequence.
    end script
    -- Set m and p to lists of the same length as the input. Their initial contents don't matter!
    copy aList to o's m
    copy aList to o's p

    set bestLength to 0
    repeat with i from 1 to (count o's inputList)
        -- Comments adapted from those in the Wikipedia article — as far as they can be understood!
        -- Binary search for the largest possible 'lo' ≤ bestLength such that inputList[m[lo]] ≤ inputList[i].
        set lo to 1
        set hi to bestLength
        repeat until (lo > hi)
            set mid to (lo + hi + 1) div 2
            if (item (item mid of o's m) of o's inputList < item i of o's inputList) then
                set lo to mid + 1
            else
                set hi to mid - 1
            end if
        end repeat
        -- After searching, lo is 1 greater than the length of the longest prefix of inputList[i].
        -- The predecessor of inputList[i] is the last index of the subsequence of length lo - 1.
        if (lo > 1) then set item i of o's p to item (lo - 1) of o's m
        set item lo of o's m to i
        -- If we found a subsequence longer than or the same length as any we've found yet,
        -- update bestLength and store the end index associated with it.
        if (lo > bestLength) then
            set bestLength to lo
            set bestEndIndices to {item bestLength of o's m}
        else if (lo = bestLength) then
            set end of bestEndIndices to item bestLength of o's m
        end if
    end repeat
    -- Reconstruct the longest increasing subsequence(s).
    set output to {}
    if (bestLength > 0) then
        repeat with k in bestEndIndices
            set o's subsequence to {}
            repeat bestLength times
                set beginning of o's subsequence to item k of o's inputList
                set k to item k of o's p
            end repeat
            set end of output to o's subsequence
        end repeat
    end if

    return output
end longestIncreasingSubsequences

-- Task code and other tests:
local tests, output, input
set tests to {{3, 2, 6, 4, 5, 1}, {0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15}, ¬
    {9, 10, 11, 3, 8, 9, 6, 7, 4, 5}, {4, 5, 5, 6}, {5, 5}}
set output to {}
repeat with input in tests
    set end of output to {finds:longestIncreasingSubsequences(input's contents)}
end repeat
return output
