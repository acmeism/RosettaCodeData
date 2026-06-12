on sumOfDivisors(n)
    if (n < 1) then return 0
    set sum to 0
    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set sum to sum + limit
        set limit to limit - 1
    end if
    repeat with i from 1 to limit
        if (n mod i is 0) then set sum to sum + i + n div i
    end repeat

    return sum
end sumOfDivisors

on task()
    set output to {}
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    repeat with i from 0 to 80 by 20
        set thisLine to {}
        repeat with j from 1 to 20
            set end of thisLine to text -4 thru -1 of ("   " & sumOfDivisors(i + j))
        end repeat
        set end of output to thisLine as text
    end repeat
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end task

return task()
