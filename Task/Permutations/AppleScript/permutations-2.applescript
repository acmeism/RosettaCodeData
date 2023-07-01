to DoPermutations(aList, n)
    --> Heaps's algorithm (Permutation by interchanging pairs)
    if n = 1 then
        tell (a reference to PermList) to copy aList to its end
        -- or: copy aList as text (for concatenated results)
    else
        repeat with i from 1 to n
            DoPermutations(aList, n - 1)
            if n mod 2 = 0 then -- n is even
                tell aList to set [item i, item n] to [item n, item i] -- swaps items i and n of aList
            else
                tell aList to set [item 1, item n] to [item n, item 1] -- swaps items 1 and n of aList
            end if
        end repeat
    end if
    return (a reference to PermList) as list
end DoPermutations

--> Example 1 (list of words)
set [SourceList, PermList] to [{"Good", "Johnny", "Be"}, {}]
DoPermutations(SourceList, SourceList's length)
--> result (value of PermList)
{{"Good", "Johnny", "Be"}, {"Johnny", "Good", "Be"}, {"Be", "Good", "Johnny"}, ¬
    {"Good", "Be", "Johnny"}, {"Johnny", "Be", "Good"}, {"Be", "Johnny", "Good"}}

--> Example 2 (characters with concatenated results)
set [SourceList, PermList] to [{"X", "Y", "Z"}, {}]
DoPermutations(SourceList, SourceList's length)
--> result (value of PermList)
{"XYZ", "YXZ", "ZXY", "XZY", "YZX", "ZYX"}

--> Example 3 (Integers)
set [SourceList, Permlist] to [{1, 2, 3}, {}]
DoPermutations(SourceList, SourceList's length)
--> result (value of Permlist)
{{1, 2, 3}, {2, 1, 3}, {3, 1, 2}, {1, 3, 2}, {2, 3, 1}, {3, 2, 1}}

--> Example 4 (Integers with concatenated results)
set [SourceList, Permlist] to [{1, 2, 3}, {}]
DoPermutations(SourceList, SourceList's length)
--> result (value of Permlist)
{"123", "213", "312", "132", "231", "321"}
