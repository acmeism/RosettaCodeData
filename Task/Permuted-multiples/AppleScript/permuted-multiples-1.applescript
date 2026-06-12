use AppleScript version "2.3.1" -- Mac OS X 10.9 (Mavericks) or later.
use sorter : script "Insertion Sort" -- <https://www.rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#AppleScript>

on decDigits(n)
    set digits to {n mod 10 as integer}
    set n to n div 10
    repeat until (n = 0)
        set beginning of digits to n mod 10 as integer
        set n to n div 10
    end repeat
    return digits
end decDigits

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set {output, n, n10, steps} to {{}, 126, 1000, 0}
    repeat
        if (n * 6 < n10) then
            set steps to steps + 1
            set nl to decDigits(n)
            tell sorter to sort(nl, 1, -1)
            set found to true
            repeat with i from 2 to 6
                set inl to decDigits(n * i)
                tell sorter to sort(inl, 1, -1)
                if (inl ≠ nl) then
                    set found to false
                    exit repeat
                end if
            end repeat
            if (found) then exit repeat
            set n to n + 3
        else
            set end of output to "Nothing below " & n10 & (" (" & steps & " steps)")
            set n to n10 + 26 -- set n to n10 * 1.26 as integer
            set n10 to n10 * 10
            -- set steps to 0
        end if
    end repeat

    set end of output to "    n = " & n & (" (" & steps & " steps altogether)")
    repeat with i from 2 to 6
        set end of output to (i as text) & " * n = " & i * n
    end repeat

    return join(output, linefeed)
end task

task()
