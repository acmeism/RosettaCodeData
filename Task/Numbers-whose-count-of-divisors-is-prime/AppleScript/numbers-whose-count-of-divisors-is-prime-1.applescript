on countFactors(n) -- Positive ns only.
    if (n < 4) then return 2 - ((n = 1) as integer)
    set factorCount to 2
    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set factorCount to 3
        set limit to limit - 1
    end if
    repeat with i from 2 to limit
        if (n mod i = 0) then set factorCount to factorCount + 2
    end repeat

    return factorCount
end countFactors

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set limit to 100000 - 1
    set nWidth to (count (limit as text))
    set inset to "        "'s text 1 thru (nWidth - 1)
    set output to {"Positive integers < " & (limit + 1) & " whose divisor count is an odd prime:"}
    set row to {}
    set counter to 0
    repeat with sqrt from 2 to (limit ^ 0.5 div 1)
        set n to sqrt * sqrt
        if (countFactors(countFactors(n)) = 2) then
            set counter to counter + 1
            set row's end to (inset & n)'s text -nWidth thru -1
            if ((count row) = 10) then
                set output's end to join(row, "  ")
                set row to {}
            end if
        end if
    end repeat
    if (row ≠ {}) then set output's end to join(row, "  ")
    set output's end to linefeed & counter & " such integers"

    return join(output, linefeed)
end task

task()
