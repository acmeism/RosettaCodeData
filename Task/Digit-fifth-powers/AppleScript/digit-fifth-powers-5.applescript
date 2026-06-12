on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on digitNthPowers(pwr)
    if ((pwr < 2) or (pwr > 13)) then return missing value -- Clear non-starter or too high for AppleScript.
    -- Trusting the theory in the Julia solution, work out how many digits are needed.
    set digits to {missing value}
    set digitCount to 1
    repeat until ((9 ^ pwr) * digitCount < (10 ^ digitCount))
        set digitCount to digitCount + 1
        set end of digits to missing value
    end repeat
    set hits to {}
    set total to 0

    script o
        on dnp(slot, dmin, dmax, sum)
            -- Recursive handler. Inherits the variables set before this script object.
            -- slot: current slot in digits.
            -- dmin, dmax: range of digit values to try in it.
            -- sum: sum of 5th powers at the calling level.
            repeat with d from dmin to dmax
                set digits's item slot to d
                if (slot < digitCount) then
                    dnp(slot + 1, 0, d, sum + d ^ pwr)
                else
                    copy digits to checklist
                    set sum to (sum + (d ^ pwr)) div 1
                    set temp to sum
                    set d to temp mod 10
                    repeat while (checklist contains {d})
                        repeat with i from 1 to digitCount
                            if (checklist's item i = d) then
                                set checklist's item i to missing value
                                exit repeat
                            end if
                        end repeat
                        set temp to temp div 10
                        set d to temp mod 10
                    end repeat
                    if (((count checklist each integer) = 0) and (sum > (2 ^ pwr))) then
                        set end of hits to sum
                        set total to total + sum
                    end if
                end if
            end repeat
        end dnp
    end script
    o's dnp(1, 1, 9, 0.0)

    if (hits = {}) then return missing value
    return join(hits, " + ") & " = " & total
end digitNthPowers

join({digitNthPowers(4), digitNthPowers(5), digitNthPowers(13)}, linefeed)
