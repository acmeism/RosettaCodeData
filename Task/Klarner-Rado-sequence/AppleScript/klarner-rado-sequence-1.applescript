-- Is n in the Klarner-Rado sequence?
-- Fully recursive:
(*
on isKlarnerRado(n)
    return ((n = 1) or ((n mod 3 = 1) and (isKlarnerRado(n div 3))) or ¬
        ((n mod 2 = 1) and (isKlarnerRado(n div 2))))
end isKlarnerRado
*)

-- With tail call elimination. About a minute faster than the above in this script.
-- Interestingly, leaving out the 'else's and comparing n mod 2 directly with 0 slows it down!
on isKlarnerRado(n)
    repeat
        if ((n = 1) or ((n mod 3 = 1) and (isKlarnerRado(n div 3)))) then
            return true
        else if (n mod 2 < 1) then
            return false
        else
            set n to n div 2
        end if
    end repeat
end isKlarnerRado

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to {"First 100 elements:"}
    set n to 0
    set |count| to 0
    set K to {}
    repeat until (|count| = 100)
        set n to n + 1
        if (isKlarnerRado(n)) then
            set K's end to n
            set |count| to |count| + 1
        end if
    end repeat
    repeat with i from 1 to 100 by 20
        set output's end to join(K's items i thru (i + 19), "  ")
    end repeat

    repeat with this in {{1000, "1,000th element: "}, {10000, "10,000th element: "}, {100000, "100,000th element: "}, ¬
        {1000000, "1,000,000th element: "}}
        set {target, spiel} to this
        repeat until (|count| = target)
            set n to n + 1
            if (isKlarnerRado(n)) then set |count| to |count| + 1
        end repeat
        set output's end to spiel & n
    end repeat

    return join(output, linefeed)
end task

task()
