-- Based on the heap sort algorithm ny J.W.J. Williams.
on getMedian(theList, l, r)
    script o
        property lst : theList's items l thru r -- Copy of the range to be searched.

        -- Sift a value down into the heap from a given root node.
        on siftDown(siftV, root, endOfHeap)
            set child to root * 2
            repeat until (child comes after endOfHeap)
                set childV to item child of my lst
                if (child comes before endOfHeap) then
                    set child2 to child + 1
                    set child2V to item child2 of my lst
                    if (child2V > childV) then
                        set child to child2
                        set childV to child2V
                    end if
                end if

                if (childV > siftV) then
                    set item root of my lst to childV
                    set root to child
                    set child to root * 2
                else
                    exit repeat
                end if
            end repeat
            set item root of my lst to siftV
        end siftDown
    end script

    set r to (r - l + 1)
    -- Arrange the sort range into a "heap" with its "top" at the leftmost position.
    repeat with i from (r + 1) div 2 to 1 by -1
        tell o to siftDown(item i of its lst, i, r)
    end repeat

    -- Work the heap as if extracting the values that would come after the median when sorted.
    repeat with endOfHeap from r to (r - (r + 1) div 2 + 2) by -1
        tell o to siftDown(item endOfHeap of its lst, 1, endOfHeap - 1)
    end repeat
    -- Extract the median itself, now at the top of the heap.
    set median to beginning of o's lst
    -- If the range has an even number of items, also get the value that would come before the median
    -- just obtained. By now it's either the second or third item in the heap, so no need to sift for it.
    -- Get the average if it and the median.
    if (r mod 2 is 0) then
        set median2 to item 2 of o's lst
        if ((r > 2) and (item 3 of o's lst > median2)) then set median2 to item 3 of o's lst
        set median to (median + median2) / 2
    end if

    return median
end getMedian

-- Demo:
local testList
set testList to {}
repeat with i from 1 to 8
    set end of testList to (random number 500) / 5
end repeat
return {|numbers|:testList, median:getMedian(testList, 1, (count testList))}
