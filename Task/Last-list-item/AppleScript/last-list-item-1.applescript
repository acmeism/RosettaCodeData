on lastListItem(lst)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ", "
    set output to {"Steps:", "{" & lst & "}   ← Original"}
    set len to (count lst)
    if (len > 1) then
        repeat with len from len to 3 by -1
            set {i, j} to {1, 2}
            set {s1, s2} to lst
            if (s2 < s1) then set {i, s1, j, s2} to {j, s2, i, s1}
            repeat with k from 3 to len
                set v to lst's item k
                if (v < s1) then
                    set {i, s1, j, s2} to {k, v, i, s1}
                else if (v < s2) then
                    set {j, s2} to {k, v}
                end if
            end repeat
            tell lst to set {item i, item j} to {missing value, missing value}
            set lst to lst's numbers
            set lst's end to s1 + s2
            set output's end to "{" & lst & "}   ← " & s1 & " + " & s2 & " = " & result
        end repeat
        tell lst to set end of output to "{" & (beginning + end) & "}   ← " & beginning & " + " & end & " = " & (beginning + end)
    end if
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid
    return output
end lastListItem

lastListItem({6, 81, 243, 14, 25, 49, 123, 69, 11})
