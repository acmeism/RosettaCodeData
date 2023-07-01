on josephus(n, k, s)
    script o
        property living : {}
    end script

    repeat with i from 1 to n
        set end of o's living to i
    end repeat

    set startPosition to k
    repeat until (n = s) -- Keep going round the circle until only s prisoners remain.
        set circleSize to n
        if (n < k) then
            set i to (startPosition - 1) mod circleSize + 1
            set item i of o's living to missing value
            set n to n - 1
        else
            repeat with i from startPosition to circleSize by k
                set item i of o's living to missing value
                set n to n - 1
                if (n = s) then exit repeat
            end repeat
        end if
        set startPosition to i + k - circleSize
        set o's living to o's living's integers
    end repeat

    return o's living
end josephus

josephus(41, 3, 1) --> {31}
josephus(41, 3, 6) --> {2, 4, 16, 22, 31, 35}
