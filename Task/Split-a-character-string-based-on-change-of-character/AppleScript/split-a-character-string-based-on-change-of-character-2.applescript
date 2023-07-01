on splitAtCharacterChanges(input)
    set len to (count input)
    if (len < 2) then return input
    set chrs to input's characters
    set currentChr to beginning of chrs
    considering case
        repeat with i from 2 to len
            set thisChr to item i of chrs
            if (thisChr is not currentChr) then
                set item i of chrs to ", " & thisChr
                set currentChr to thisChr
            end if
        end repeat
    end considering
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    set output to chrs as text
    set AppleScript's text item delimiters to astid

    return output
end splitAtCharacterChanges

-- Test code:
splitAtCharacterChanges("gHHH5YY++///\\")
