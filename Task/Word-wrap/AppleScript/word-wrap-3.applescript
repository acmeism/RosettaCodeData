on wrapParagraph(para, lineWidth)
    set theLines to {}
    set spaceTab to space & tab
    set len to (count para)
    set i to 1
    repeat until (i > len)
        set j to i + lineWidth - 1
        if (j < len) then
            repeat with j from j to i by -1
                if (character j of para is in spaceTab) then exit repeat
            end repeat
            -- The "greedy" algorithm keeps words which are longer than or
            -- the same length as the line width intact. Do the same here.
            if (j = i) then
                repeat with j from (i + lineWidth) to len
                    if (character j of para is in spaceTab) then exit repeat
                end repeat
            end if
        else
            set j to len
        end if
        set end of theLines to text i thru j of para
        set i to j + 1
    end repeat

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to character id 8232 -- U+2028 (LINE SEPARATOR).
    set output to theLines as text
    set AppleScript's text item delimiters to astid

    return output
end wrapParagraph
