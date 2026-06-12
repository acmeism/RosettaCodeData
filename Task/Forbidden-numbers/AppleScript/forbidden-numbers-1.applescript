on isForbidden(n)
    repeat while ((n mod 4 = 0) and (n > 7))
        set n to n div 4
    end repeat

    return (n mod 8 = 7)
end isForbidden

on forbiddenCount(limit)
    set {counter, p4, n} to {0, 1, 7}
    repeat while (n ≤ limit)
        set p4 to p4 * 4
        set counter to counter + (limit - n) div (p4 + p4) + 1
        set n to p4 * 7
    end repeat

    return counter
end forbiddenCount

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on intToText(int, separator)
    set groups to {}
    repeat while (int > 999)
        set groups's beginning to ((1000 + (int mod 1000 as integer)) as text)'s text 2 thru 4
        set int to int div 1000
    end repeat
    set groups's beginning to int as integer
    return join(groups, separator)
end intToText

on task()
    set output to {"First fifty forbidden numbers:"}
    set {counter, n, row} to {0, 0, {}}
    repeat until (counter = 50)
        set n to n + 1
        if (isForbidden(n)) then
            set counter to counter + 1
            set row's end to ("   " & n)'s text -4 thru -1
            if (counter mod 10 = 0) then
                set output's end to join(row, "")
                set row to {}
            end if
        end if
    end repeat
    set output's end to row
    repeat with target in {500, 5000, 50000, 500000, 5000000, 50000000, 500000000}
        set output's end to intToText(forbiddenCount(target), ",") & ¬
            " forbidden numbers ≤ " & intToText(target, ",")
    end repeat
    return join(output, linefeed)
end task

task()
