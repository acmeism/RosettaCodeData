use AppleScript version "2.3.1" -- Mac OS 10.9 (Mavericks) or later.
use sorter : script "Insertion sort" -- https://www.rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#AppleScript.

on sortValuesAtIndices(values, indices)
    set indexedValues to {}
    repeat with thisIndex in indices
        set end of indexedValues to item thisIndex of values
    end repeat

    set indexCount to (count indices)

    tell sorter to sort(indexedValues, 1, indexCount)
    tell sorter to sort(indices, 1, indexCount)

    repeat with i from 1 to indexCount
        set thisIndex to item i of indices
        set item thisIndex of values to item i of indexedValues
    end repeat

    return
end sortValuesAtIndices

-- Test code:
set values to {7, 6, 5, 4, 3, 2, 1, 0}
set indices to {7, 2, 8} -- AppleScript indices are one-based.
sortValuesAtIndices(values, indices)
return values
