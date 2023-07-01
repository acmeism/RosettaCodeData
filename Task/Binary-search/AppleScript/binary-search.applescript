on binarySearch(n, theList, l, r)
    repeat until (l = r)
        set m to (l + r) div 2
        if (item m of theList < n) then
            set l to m + 1
        else
            set r to m
        end if
    end repeat

    if (item l of theList is n) then return l
    return missing value
end binarySearch

on test(n, theList, l, r)
    set |result| to binarySearch(n, theList, l, r)
    if (|result| is missing value) then
        return (n as text) & " is not in range " & l & " thru " & r & " of the list"
    else
        return "The first occurrence of " & n & " in range " & l & " thru " & r & " of the list is at index " & |result|
    end if
end test

set theList to {1, 2, 3, 3, 5, 7, 7, 8, 9, 10, 11, 12}
return test(7, theList, 4, 11) & linefeed & test(7, theList, 7, 12) & linefeed & test(7, theList, 1, 5)
