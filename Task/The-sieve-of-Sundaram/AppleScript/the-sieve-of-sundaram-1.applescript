on sieveOfSundaram(indexRange)
    if (indexRange's class is list) then
        set n1 to beginning of indexRange
        set n2 to end of indexRange
    else
        set n1 to indexRange
        set n2 to indexRange
    end if

    script o
        property lst : {}
    end script

    set {unmarked, marked} to {true, false}
    -- Build a list of 'true's corresponding to the unmarked start numbers implied by the
    -- 1-based indices. The Python and Julia solutions note that the nth prime is approximately
    -- n * 1.2 * log(n), but the number from which it'll be derived is only about half that.
    -- 15 is added too here to ensure headroom with lower prime counts.
    set limit to (do shell script "echo '" & n2 & " * 0.6 * l(" & n2 & ") + 15'| bc -l") as integer
    set len to 1500
    repeat len times
        set end of o's lst to unmarked
    end repeat
    repeat while (len < limit)
        set o's lst to o's lst & o's lst
        set len to len + len
    end repeat

    -- Since it's a given that every third slot from 4 on will be "marked" (changed to false), there'll be
    -- no need to check these and thus no point in actually marking them! Skip the step = 3 marking sweep
    -- and the first slot of every three for marking in the subsequent sweeps.
    repeat with step from 5 to ((limit * 2) ^ 0.5 as integer) by 2
        -- Like the Phix solution, mark only from half the square of the step size, but adjusted
        -- to sync the repeat to the second slot in each group of three for marking.
        repeat with j from (step * step div 2 - (step * 2 mod 3) * step + step) to (limit - step) by (step * 3)
            set item j of o's lst to marked
            set item (j + step) of o's lst to marked
        end repeat
    end repeat

    -- Calculate the primes from the indices of the unmarked slots
    -- and store them in the list from the beginning.
    set i to 1
    set item i of o's lst to i * 2 + 1
    repeat with n from 2 to limit by 3
        if (item n of o's lst) then
            set i to i + 1
            set item i of o's lst to n * 2 + 1
            if (i = n2) then exit repeat
        end if
        if (item (n + 1) of o's lst) then
            set i to i + 1
            set item i of o's lst to n * 2 + 3 -- ((n + 1) * 2) + 1)
            if (i = n2) then exit repeat
        end if
    end repeat
    -- set beginning of o's lst to 2 -- Uncomment if required.

    return items n1 thru n2 of o's lst
end sieveOfSundaram

-- Task code:
on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    --set r1 to sieveOfSundaram({1, 100})
    --set r2 to sieveOfSundaram(1000000)
    set r to sieveOfSundaram({1, 1000000})
    set r1 to items 1 thru 100 of r
    set r2 to item 1000000 of r
    set output to {"1st to 100th Sundaram primes:"}
    repeat with i from 1 to 100 by 10
        set end of output to join(items i thru (i + 9) of r1, "  ")
    end repeat
    set end of output to "1,000,000th: "
    set end of output to r2

    return join(output, linefeed)
end task

task()
