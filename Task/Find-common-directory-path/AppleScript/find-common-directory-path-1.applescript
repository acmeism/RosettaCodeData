on commonDirectoryPath(thePaths, separator)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to separator
    set path1 to thePaths's beginning
    set path1Components to path1's text items
    set maxC to (count path1Components)
    repeat with nextPath in (thePaths's rest)
        if (maxC = 0) then exit repeat
        set theseComponents to nextPath's text items
        set componentCount to (count theseComponents)
        if (componentCount < maxC) then set maxC to componentCount
        repeat with c from 1 to maxC
            if (theseComponents's item c ≠ path1Components's item c) then
                set maxC to c - 1
                exit repeat
            end if
        end repeat
    end repeat
    if (maxC > 0) then
        set commonPath to path1's text 1 thru text item maxC
    else
        set commonPath to ""
    end if
    set AppleScript's text item delimiters to astid

    return commonPath
end commonDirectoryPath

return commonDirectoryPath({"/home/user1/tmp/coverage/test", ¬
    "/home/user1/tmp/covert/operator", ¬
    "/home/user1/tmp/coven/members"}, "/")
