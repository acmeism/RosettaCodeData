on dayOfWeek(yyyymmdd)
    tell yyyymmdd to set {y, m, d} to {word 1 as integer, word 2 as integer, word 3 as integer}
    set doomsdayForYear to (y + y div 4 - y div 100 + y div 400 + 2) -- (mod 7 further down anyway)
    if ((m < 3) and ((y mod 4 = 0) and (y mod 100 > 0) or (y mod 400 = 0))) then set m to m + 12
    set doomsdayInMonth to item m of {3, 28, 7, 4, 2, 6, 4, 8, 5, 10, 7, 12, 4, 29}

    return item ((doomsdayForYear + d - doomsdayInMonth + 28) mod 7 + 1) of ¬
        {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
end dayOfWeek

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set dateStrings to {"1800-01-06", "1875-03-29", "1915-12-07", "1970-12-23", "2043-05-14", "2077-02-12", "2101-04-02"}
    set output to {}
    repeat with yyyymmdd in dateStrings
        set end of output to yyyymmdd & " --> " & dayOfWeek(yyyymmdd)
    end repeat
    return join(output, linefeed)
end task

task()
