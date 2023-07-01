on hailstoneSequence(n)
    script o
        property sequence : {n}
    end script

    repeat until (n = 1)
        if (n mod 2 is 0) then
            set n to n div 2
        else
            set n to 3 * n + 1
        end if
        set end of o's sequence to n
    end repeat

    return o's sequence
end hailstoneSequence

set n to 27
tell hailstoneSequence(n)
    return {n:n, |length of sequence|:(its length), |first 4 numbers|:items 1 thru 4, |last 4 numbers|:items -4 thru -1}
end tell
