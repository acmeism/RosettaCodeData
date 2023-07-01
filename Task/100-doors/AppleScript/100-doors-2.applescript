on _100doors()
    script o
        property doors : {}
    end script
    repeat 100 times
        set end of o's doors to false -- false = "not open".
    end repeat
    repeat with pass from 1 to 100
        if (not item pass of o's doors) then set item pass of o's doors to pass
        repeat with d from (pass + pass) to 100 by pass
            set item d of o's doors to (not item d of o's doors)
        end repeat
    end repeat

    return o's doors's integers
end _100doors

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

return "Open doors:
" & join(_100doors(), ", ")
