on KlarnerRadoSequence(target)
    -- To find a million KR numbers with this method nominally needs a list with at least 54,381,285
    -- slots. But the number isn't known in advance, "growing" a list to the required length would
    -- take forever, and accessing its individual items could also take a while. Instead, K will
    -- here contain reasonably sized and quickly produced sublists which are added as needed.
    -- The 1-based referencing calculations will be ((index - 1) div sublistLen + 1) for the sublist
    -- and ((index - 1) mod sublistLen + 1) for the slot within it.
    set sublistLen to 10000
    script o
        property spare : makeList(sublistLen, missing value)
        property K : {spare's items}
    end script

    -- Insert the initial 1, start the KR counter at 1, start the number-to-test variable at 2.
    set {o's K's beginning's 1st item, |count|, n} to {1, 1, 2}
    -- Test the first, second, third, and fifth of every six consecutive numbers starting at 2.
    -- These are known to be divisible by 2 or by 3 and the fourth and sixth known not to be.
    -- If the item at index (n div 2) or index (n div 3) isn't 'missing value', it's a number,
    -- so insert (n + 1) at index (n + 1).
    if (|count| < target) then ¬
        repeat -- Per increase of n by 6.
            -- The first of the six numbers in this range is divisible by 2.
            -- Precalculate (index - 1) for index (n div 2) to reduce code clutter and halve calculation time.
            set pre to n div 2 - 1
            if (o's K's item (pre div sublistLen + 1)'s item (pre mod sublistLen + 1) is missing value) then
            else
                -- Insert (n + 1) at index (n + 1). The 'n's in the reference calculations are for ((n + 1) - 1)!
                set o's K's item (n div sublistLen + 1)'s item (n mod sublistLen + 1) to n + 1
                set |count| to |count| + 1
                if (|count| = target) then exit repeat
            end if
            -- The second number of the six is divisible by 3.
            set n to n + 1
            set pre to n div 3 - 1
            if (o's K's item (pre div sublistLen + 1)'s item (pre mod sublistLen + 1) is missing value) then
            else
                set o's K's item (n div sublistLen + 1)'s item (n mod sublistLen + 1) to n + 1
                set |count| to |count| + 1
                if (|count| = target) then exit repeat
            end if
            -- The third is divisible by 2.
            set n to n + 1
            set pre to n div 2 - 1
            if (o's K's item (pre div sublistLen + 1)'s item (pre mod sublistLen + 1) is missing value) then
            else
                set o's K's item (n div sublistLen + 1)'s item (n mod sublistLen + 1) to n + 1
                set |count| to |count| + 1
                if (|count| = target) then exit repeat
            end if
            -- The fifth is divisible by both 2 and 3.
            set n to n + 2
            set pre2 to n div 2 - 1
            set pre3 to n div 3 - 1
            if ((o's K's item (pre2 div sublistLen + 1)'s item (pre2 mod sublistLen + 1) is missing value) and ¬
                (o's K's item (pre3 div sublistLen + 1)'s item (pre3 mod sublistLen + 1) is missing value)) then
            else
                set o's K's item (n div sublistLen + 1)'s item (n mod sublistLen + 1) to n + 1
                set |count| to |count| + 1
                if (|count| = target) then exit repeat
            end if

            -- Advance to the first number of the next six.
            set n to n + 2
            -- If another sublist is about to be needed, append one to the end of K.
            if ((n + 6) mod sublistLen < 6) then copy o's spare to o's K's end
        end repeat

    -- Once the target's reached, replace the sublists with lists containing just the numbers.
    set sublistCount to (count o's K)
    repeat with i from 1 to sublistCount
        set o's K's item i to o's K's item i's numbers
    end repeat
    -- Concatenate the number lists to leave K as a single list of numbers.
    repeat while (sublistCount > 1)
        set o's spare to o's K
        set o's K to {}
        repeat with i from 2 to sublistCount by 2
            set end of o's K to o's spare's item (i - 1) & o's spare's item i
        end repeat
        if (i < sublistCount) then set o's K's last item to o's K's end & o's spare's end
        set sublistCount to sublistCount div 2
    end repeat
    set o's K to o's K's beginning

    return o's K
end KlarnerRadoSequence

on makeList(len, content)
    script o
        property lst : {}
    end script
    if (len > 0) then
        set o's lst's end to content
        set |count| to 1
        repeat until (|count| + |count| > len)
            set o's lst to o's lst & o's lst
            set |count| to |count| + |count|
        end repeat
        if (|count| < len) then set o's lst to o's lst & o's lst's items 1 thru (len - |count|)
    end if

    return o's lst
end makeList

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    script o
        property K : KlarnerRadoSequence(1000000)
    end script
    set output to {"First 100 elements:"}
    repeat with i from 1 to 100 by 20
        set output's end to join(o's K's items i thru (i + 19), "  ")
    end repeat
    set output's end to "1,000th element: " & o's K's item 1000
    set output's end to "10,000th element: " & o's K's item 10000
    set output's end to "100,000th element: " & o's K's item 100000
    set output's end to "1,000,000th element: " & o's K's item 1000000

    return join(output, linefeed)
end task

task()
