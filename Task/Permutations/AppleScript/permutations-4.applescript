-- Translation of "Improved version of Heap's method (recursive)" found in
-- Robert Sedgewick's PDF document "Permutation Generation Methods"
-- <https://www.cs.princeton.edu/~rs/talks/perms.pdf>

on allPermutations(theList)
    script o
        -- Work list and precalculated indices for its last four items (assuming that many).
        property workList : missing value --(Set to a copy of theList below.)
        property r : (count theList)
        property rMinus1 : r - 1
        property rMinus2 : r - 2
        property rMinus3 : r - 3
        -- Output list and traversal index.
        property output : {}
        property p : 1

        -- Recursive handler.
        on prmt(l)
            -- Is the range length covered by this recursion level even?
            set rangeLenEven to ((r - l) mod 2 = 1)
            -- Tail call elimination repeat. Gives way to hard-coding for the lowest three levels.
            repeat with l from l to rMinus3
                -- Recursively permute items (l + 1) thru r of the work list.
                set lPlus1 to l + 1
                prmt(lPlus1)
                -- And again after swaps of item l with each of the items to its right
                -- (if the range l to r is even) or with the rightmost item r - l times
                -- (if the range length is odd). The "recursion" after the last swap will
                -- instead be the next iteration of this tail call elimination repeat.
                if (rangeLenEven) then
                    repeat with swapIdx from r to (lPlus1 + 1) by -1
                        tell my workList's item l
                            set my workList's item l to my workList's item swapIdx
                            set my workList's item swapIdx to it
                        end tell
                        prmt(lPlus1)
                    end repeat
                    set swapIdx to lPlus1
                else
                    repeat (r - lPlus1) times
                        tell my workList's item l
                            set my workList's item l to my workList's item r
                            set my workList's item r to it
                        end tell
                        prmt(lPlus1)
                    end repeat
                    set swapIdx to r
                end if
                tell my workList's item l
                    set my workList's item l to my workList's item swapIdx
                    set my workList's item swapIdx to it
                end tell
                set rangeLenEven to (not rangeLenEven)
            end repeat
            -- Store a copy of the work list's current state.
            set my output's item p to my workList's items
            -- Then five more with the three rightmost items permuted.
            set v1 to my workList's item rMinus2
            set v2 to my workList's item rMinus1
            set v3 to my workList's end
            set my workList's item rMinus1 to v3
            set my workList's item r to v2
            set my output's item (p + 1) to my workList's items
            set my workList's item rMinus2 to v2
            set my workList's item r to v1
            set my output's item (p + 2) to my workList's items
            set my workList's item rMinus1 to v1
            set my workList's item r to v3
            set my output's item (p + 3) to my workList's items
            set my workList's item rMinus2 to v3
            set my workList's item r to v2
            set my output's item (p + 4) to my workList's items
            set my workList's item rMinus1 to v2
            set my workList's item r to v1
            set my output's item (p + 5) to my workList's items
            set p to p + 6
        end prmt
    end script

    if (o's r < 3) then
        -- Fewer than three items in the input list.
        copy theList to o's output's beginning
        if (o's r is 2) then set o's output's end to theList's reverse
    else
        -- Otherwise prepare a list to hold (factorial of input list length) permutations …
        copy theList to o's workList
        set factorial to 2
        repeat with i from 3 to o's r
            set factorial to factorial * i
        end repeat
        set o's output to makeList(factorial, missing value)
        -- … and call o's recursive handler.
        o's prmt(1)
    end if

    return o's output
end allPermutations

on makeList(limit, filler)
    if (limit < 1) then return {}
    script o
        property lst : {filler}
    end script

    set counter to 1
    repeat until (counter + counter > limit)
        set o's lst to o's lst & o's lst
        set counter to counter + counter
    end repeat
    if (counter < limit) then set o's lst to o's lst & o's lst's items 1 thru (limit - counter)
    return o's lst
end makeList

return allPermutations({1, 2, 3, 4})
