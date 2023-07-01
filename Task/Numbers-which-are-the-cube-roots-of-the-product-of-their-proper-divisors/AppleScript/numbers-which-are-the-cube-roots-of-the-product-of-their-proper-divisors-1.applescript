on properDivisors(n)
    set output to {}

    if (n > 1) then
        set sqrt to n ^ 0.5
        set limit to sqrt div 1
        if (limit = sqrt) then
            set end of output to limit
            set limit to limit - 1
        end if
        repeat with i from limit to 2 by -1
            if (n mod i is 0) then
                set beginning of output to i
                set end of output to n div i
            end if
        end repeat
        set beginning of output to 1
    end if

    return output
end properDivisors

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to {"First 50 numbers whose cubes are the products of their proper divisors", ¬
        "(and of course whose fourth powers are the products of ALL their positive divisors):"}
    set pad to "      "
    set n to 1
    set first50 to {"    1"}
    repeat 49 times
        set n to n + 1
        repeat until ((count properDivisors(n)) = 7)
            set n to n + 1
        end repeat
        set end of first50 to text -5 thru -1 of (pad & n)
    end repeat
    repeat with i from 1 to 41 by 10
        set end of output to join(first50's items i thru (i + 9), "")
    end repeat
    set |count| to 50
    repeat with target in {500, 5000, 50000}
        repeat with |count| from (|count| + 1) to target
            set n to n + 1
            repeat until ((count properDivisors(n)) = 7)
                set n to n + 1
            end repeat
        end repeat
        set end of output to text -6 thru -1 of (pad & |count|) & "th: " & text -6 thru -1 of (pad & n)
    end repeat

    return join(output, linefeed)
end task

task()
