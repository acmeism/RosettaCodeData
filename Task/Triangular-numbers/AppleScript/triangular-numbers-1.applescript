on rSimplexNumber(r, n)
    set n to n - 1 -- "nth" is 0-based in the formula!
    set numerator to n
    set denominator to 1
    repeat with dimension from 2 to r
        set numerator to numerator * (n + dimension - 1)
        set denominator to denominator * dimension
    end repeat

    return numerator div denominator
end rSimplexNumber

on triangularRoot(x)
    return ((8 * x + 1) ^ 0.5 - 1) / 2
end triangularRoot

on tetrahedralRoot(x)
    -- NOT (((9 * (x ^ 2) - 1 / 27) ^ 0.5 + 3 * x) ^ (1 / 3)) * 2 - 1  !
    return (((9 * (x ^ 2) - 1 / 27) ^ 0.5 + 3 * x) ^ (1 / 3)) - 1
end tetrahedralRoot

on pentatopicRoot(x)
    return (((24 * x + 1) ^ 0.5 * 4 + 5) ^ 0.5 - 3) / 2
end pentatopicRoot

on intToText(int)
    set txt to ""
    repeat while (int > 99999999)
        set txt to ((100000000 + int mod 100000000) as integer as text)'s text 2 thru 9 & txt
        set int to int div 100000000
    end repeat
    return (int as text) & txt
end intToText

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to {}
    set padding to "               "
    set columnWidth to (count intToText(rSimplexNumber(12, 30))) + 2
    repeat with rt in {{2, "triangular"}, {3, "tetrahedral"}, {5, "pentatopic"}, {12, "12-simplex"}}
        set {r, type} to rt
        set end of output to linefeed & "First thirty " & type & " numbers:"
        set these6 to {}
        repeat with n from 1 to 30
            set this to intToText(rSimplexNumber(r, n))
            set these6's end to (padding & this)'s text -columnWidth thru -1
            if (n mod 6 = 0) then
                set end of output to join(these6, "")
                set these6 to {}
            end if
        end repeat
    end repeat
    repeat with n in {7140, 21408696, 2.6728085384E+10, 1.4545501785001E+13}
        set end of output to linefeed & "Roots of " & intToText(n) & ":"
        set end of output to "  Triangular root: " & triangularRoot(n)
        set end of output to "  Tetrahedral root: " & tetrahedralRoot(n)
        set end of output to "  Pentatopic root: " & pentatopicRoot(n)
    end repeat
    return join(output, linefeed)
end task

return task()
