on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on digit5thPowers()
    set sums to {}
    set total to 0
    repeat with n from (2 ^ 5) to ((9 ^ 5) * 6)
        set temp to n
        set sum to (temp mod 10) ^ 5
        repeat while (temp > 9)
            set temp to temp div 10
            set sum to sum + (temp mod 10) ^ 5
        end repeat
        if (sum = n) then
            set end of sums to n
            set total to total + n
        end if
    end repeat
    return join(sums, " + ") & " = " & total
end digit5thPowers

digit5thPowers()
