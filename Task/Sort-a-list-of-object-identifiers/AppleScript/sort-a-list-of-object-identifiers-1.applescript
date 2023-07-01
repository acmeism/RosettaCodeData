(* Shell sort
Algorithm: Donald Shell, 1959.
*)

on ShellSort(theList, l, r)
    script o
        property lst : theList
    end script

    set listLength to (count theList)
    if (listLength > 1) then
        -- Convert negative and/or transposed range indices.
        if (l < 0) then set l to listLength + l + 1
        if (r < 0) then set r to listLength + r + 1
        if (l > r) then set {l, r} to {r, l}

        -- Do the sort.
        set stepSize to (r - l + 1) div 2
        repeat while (stepSize > 0)
            repeat with i from (l + stepSize) to r
                set currentValue to item i of o's lst
                repeat with j from (i - stepSize) to l by -stepSize
                    set thisValue to item j of o's lst
                    if (currentValue < thisValue) then
                        set item (j + stepSize) of o's lst to thisValue
                    else
                        set j to j + stepSize
                        exit repeat
                    end if
                end repeat
                if (j < i) then set item j of o's lst to currentValue
            end repeat
            set stepSize to (stepSize / 2.2) as integer
        end repeat
    end if

    return -- nothing. The input list has been sorted in place.
end ShellSort
property sort : ShellSort

-- Test code: sort items 1 thru -1 (ie. all) of a list of strings, treating numeric portions numerically.
set theList to {"1.3.6.1.4.1.11.2.17.19.3.4.0.10", "1.3.6.1.4.1.11.2.17.5.2.0.79", "1.3.6.1.4.1.11.2.17.19.3.4.0.4", ¬
    "1.3.6.1.4.1.11150.3.4.0.1", "1.3.6.1.4.1.11.2.17.19.3.4.0.1", "1.3.6.1.4.1.11150.3.4.0"}
considering numeric strings
    sort(theList, 1, -1)
end considering
return theList
