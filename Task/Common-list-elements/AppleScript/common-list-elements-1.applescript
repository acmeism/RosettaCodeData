use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use sorter : script "Insertion Sort" -- <https://www.rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#AppleScript>

on commonListElements(listOfLists)
    set mutableSet to current application's class "NSMutableSet"'s setWithArray:(beginning of listOfLists)
    repeat with i from 2 to (count listOfLists)
        tell mutableSet to intersectSet:(current application's class "NSSet"'s setWithArray:(item i of listOfLists))
    end repeat

    return (mutableSet's allObjects()) as list
end commonListElements

set commonElements to commonListElements({{2, 5, 1, 3, 8, 9, 4, 6}, {3, 5, 6, 2, 9, 8, 4}, {1, 3, 7, 6, 9}})
tell sorter to sort(commonElements, 1, -1)
return commonElements
