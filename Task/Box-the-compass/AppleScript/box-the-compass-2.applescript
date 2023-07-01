on degreesToCompassPoint(degrees)
    set cardinals to {"north", "east", "south", "west"}
    set idx to ((degrees / 11.25) as integer) mod 32
    set qIdx to idx mod 8
    if (qIdx = 0) then return cardinals's item (idx div 8 + 1)
    set ns to cardinals's item (3 - (idx + 24) div 16 mod 2 * 2)
    set ew to cardinals's item ((idx div 16 + 1) * 2)
    if (idx mod 16 > 7) then set qIdx to 8 - qIdx
    if (qIdx = 1) then return ns & " by " & ew
    if (qIdx = 2) then return ns & "-" & ns & ew
    if (qIdx = 3) then return ns & ew & " by " & ns
    if (qIdx = 4) then return ns & ew
    if (qIdx = 5) then return ns & ew & " by " & ew
    if (qIdx = 6) then return ew & "-" & ns & ew
    return ew & " by " & ns -- qIdx = 7.
end degreesToCompassPoint

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to {"", "Index  Compass point          Degrees"}
    set inputs to {0.0, 16.87, 16.88, 33.75, 50.62, 50.63, 67.5, 84.37, 84.38, 101.25, 118.12, ¬
        118.13, 135.0, 151.87, 151.88, 168.75, 185.62, 185.63, 202.5, 219.37, 219.38, 236.25, ¬
        253.12, 253.13, 270.0, 286.87, 286.88, 303.75, 320.62, 320.63, 337.5, 354.37, 354.38}
    repeat with i from 1 to (count inputs)
        set degrees to inputs's item i
        set cpid to (degreesToCompassPoint(degrees))'s id
        set cpid's first item to (cpid's beginning) mod 32 + 64
        set compassPoint to string id cpid
        set degrees to degrees as text
        set entry to {text -2 thru -1 of (space & ((i - 1) mod 32 + 1)), ¬
            text 1 thru 18 of (compassPoint & "              "), ¬
            text (offset of "." in degrees) thru end of ("   " & degrees)}
        set end of output to join(entry, "     ")
    end repeat

    join(output, linefeed)
end task

task()
