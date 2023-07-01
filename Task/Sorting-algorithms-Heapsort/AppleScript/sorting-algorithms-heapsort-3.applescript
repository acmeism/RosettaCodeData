-- In-place ternary heap sort.
-- Heap sort algorithm: J.W.J. Williams.
on heapSort(theList, l, r) -- Sort items l thru r of theList.
    set listLen to (count theList)
    if (listLen < 2) then return
    -- Convert negative and/or transposed range indices.
    if (l < 0) then set l to listLen + l + 1
    if (r < 0) then set r to listLen + r + 1
    if (l > r) then set {l, r} to {r, l}

    script o
        -- The list as a script property to allow faster references to its items.
        property lst : theList
        -- In a ternary heap, the list index of each node's first child is (node index * 3) - (l * 2 - 1). Preset the constant part.
        property const : l * 2 - 1

        -- Private subhandler: sift a value down into the heap from a given node.
        on siftDown(siftV, node, endOfHeap)
            set child to node * 3 - const
            repeat until (child comes after endOfHeap)
                set childV to my lst's item child
                if (child comes before endOfHeap) then
                    set child2 to child + 1
                    set child2V to my lst's item child2
                    if (child2V > childV) then
                        set child to child2
                        set childV to child2V
                    end if
                    if (child2 comes before endOfHeap) then
                        set child3 to child2 + 1
                        set child3V to my lst's item child3
                        if (child3V > childV) then
                            set child to child3
                            set childV to child3V
                        end if
                    end if
                end if
                if (childV > siftV) then
                    set my lst's item node to childV
                    set node to child
                    set child to node * 3 - const
                else
                    exit repeat
                end if
            end repeat

            -- Insert the sifted-down value at the node reached.
            set my lst's item node to siftV
        end siftDown
    end script

    -- Arrange the sort range into a ternary "heap" with its "top" at the leftmost position.
    repeat with i from (l + r) div 3 to l by -1
        tell o to siftDown(its lst's item i, i, r)
    end repeat
    -- Unpick the heap.
    repeat with endOfHeap from r to (l + 1) by -1
        set endV to o's lst's item endOfHeap
        set o's lst's item endOfHeap to o's lst's item l
        tell o to siftDown(endV, l, endOfHeap - 1)
    end repeat

    return -- nothing
end heapSort
property sort : heapSort

-- Demo:
local aList
set aList to {75, 46, 8, 43, 20, 9, 25, 89, 19, 29, 16, 71, 44, 23, 17, 99, 79, 97, 19, 75, 32, 27, 42, 93, 75}
sort(aList, 1, -1) -- Sort items 1 thru -1 of aList.
return aList
