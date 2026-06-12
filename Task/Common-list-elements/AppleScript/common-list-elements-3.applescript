use AppleScript version "2.3.1" -- Mac OS X 10.9 (Mavericks) or later.
use sorter : script "Insertion Sort" -- <https://www.rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#AppleScript>

on commonListElements(listOfLIsts)
    script o
        property list1 : beginning of listOfLIsts
    end script

    set common to {}
    set listCount to (count listOfLIsts)
    repeat with i from 1 to (count o's list1)
        set thisElement to {item i of o's list1}
        if (thisElement is not in common) then
            repeat with j from 2 to listCount
                set OK to (item j of listOfLIsts contains thisElement)
                if (not OK) then exit repeat
            end repeat
            if (OK) then set end of common to beginning of thisElement
        end if
    end repeat

    return common
end commonListElements

set commonElements to commonListElements({{2, 5, 1, 3, 8, 9, 4, 6}, {3, 5, 6, 2, 9, 8, 4}, {1, 3, 7, 6, 9}})
tell sorter to sort(commonElements, 1, -1)
return commonElements
