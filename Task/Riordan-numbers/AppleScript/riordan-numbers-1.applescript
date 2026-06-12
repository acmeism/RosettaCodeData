on riordanNumbers(n)
    set a to {1, 0}
    repeat with n from 3 to n
        set {an2, an1} to a's items -2 thru -1
        set a's end to (n - 2) * (an1 + an1 + 3 * an2) div n
    end repeat

    return a
end riordanNumbers

on intToText(int, separator)
    set groups to {}
    repeat while (int > 999)
        set groups's beginning to ((1000 + (int mod 1000 as integer)) as text)'s text 2 thru 4
        set int to int div 1000
    end repeat
    set groups's beginning to int as integer
    return join(groups, separator)
end intToText

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set riordans to riordanNumbers(32)
    set columnWidth to (count intToText(riordans's item 32, ",")) + 2
    set output to {"1st 32 Riordan numbers:"}
    set row to {}
    repeat with i from 1 to 32 by 4
        repeat with j from i to (i + 3)
            set end of row to text -columnWidth thru -1 of ¬
                ("                    " & intToText(riordans's item j, ","))
        end repeat
        set end of output to join(row, "")
        set row to {}
    end repeat
    return join(output, linefeed)
end task

task()
