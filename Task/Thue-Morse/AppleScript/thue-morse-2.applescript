on ThueMorse(sequenceLength)
    if (sequenceLength < 1) then return ""

    script o
        property sequence : {0}
    end script

    set counter to 1
    set cycleEnd to 1
    set i to 1
    repeat until (counter = sequenceLength)
        set end of o's sequence to ((item i of o's sequence) + 1) mod 2
        set counter to counter + 1
        if (i < cycleEnd) then
            set i to i + 1
        else
            set i to 1
            set cycleEnd to counter
        end if
    end repeat

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    set sequence to o's sequence as text
    set AppleScript's text item delimiters to astid

    return sequence
end ThueMorse

return linefeed & ThueMorse(64) & (linefeed & ThueMorse(65))
