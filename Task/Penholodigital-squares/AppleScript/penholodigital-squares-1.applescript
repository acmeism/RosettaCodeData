on penholodigitalSquares(base)
    set digits to "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    set output to {}
    set minFromDigits to 1
    repeat with d from 2 to (base - 1)
        set minFromDigits to minFromDigits * base + d
    end repeat
    set maxFromDigits to base - 1
    repeat with d from (base - 2) to 1 by -1
        set maxFromDigits to maxFromDigits * base + d
    end repeat
    repeat with sqrt from (round (minFromDigits ^ 0.5) rounding up) to (maxFromDigits ^ 0.5 div 1)
        set n to sqrt * sqrt
        set usedDigitValues to {0}
        set OKSoFar to true
        repeat (base - 2) times -- until (n < base)
            set d to n mod base
            if (d is in usedDigitValues) then
                set OKSoFar to false
                exit repeat
            end if
            set usedDigitValues's end to d
            set n to n div base
        end repeat
        if ((OKSoFar) and (n is not in usedDigitValues)) then ¬
            set end of output to {intToBase(sqrt, base), intToBase(sqrt * sqrt, base)}
    end repeat

    return output
end penholodigitalSquares

on intToBase(int, base)
    if ((int < 0) or (int mod 1 > 0) or (base < 2) or (base > 36)) then return missing value
    set digits to "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    set output to digits's character (int mod base + 1)
    repeat until (int < base)
        set int to int div base
        set output to digits's character (int mod base + 1) & output
    end repeat
    return output
end intToBase

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to {}
    repeat with base from 9 to 14
        set results to penholodigitalSquares(base)
        set resultCount to (count results)
        if (resultCount > 1) then
            set output's end to linefeed & "There are " & resultCount & ¬
                (" penholodigital squares in base " & base & ":")
            if (base < 13) then
                repeat with i from 1 to resultCount by 3
                    set row to {}
                    set k to i + 2
                    if (k > resultCount) then set k to resultCount
                    repeat with j from i to k
                        set end of row to join(results's item j, " ^ 2 = ")
                    end repeat
                    set output's end to join(row, "    ")
                end repeat
            else
                set output's end to "First: " & join(results's beginning, " ^ 2 = ") & ¬
                    ("    Last: " & join(results's end, " ^ 2 = "))
            end if
        else if (resultCount = 1) then
            set output's end to linefeed & "There is 1 penholodigital square in base " & ¬
                base & ":"
            set output's end to join(results's beginning, " ^ 2 = ")
        else
            set output's end to linefeed & "There are no penholodigital squares in base " & base
        end if
    end repeat
    return join(output, linefeed)
end task

task()
