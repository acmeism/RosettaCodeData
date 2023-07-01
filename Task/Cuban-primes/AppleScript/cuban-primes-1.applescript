on isPrime(n)
    -- Most of the numbers tested in this script will be huge
    -- and none will be less than 7 or divisible by 2, 3, or 5.
    (* if (n < 7) then return (n is in {2, 3, 5})
    if ((n mod 2) * (n mod 3) * (n mod 5) = 0) then return false *)
    repeat with i from 7 to (n ^ 0.5 div 1) by 30
        if ((n mod i) * (n mod (i + 4)) * (n mod (i + 6)) * (n mod (i + 10)) * ¬
            (n mod (i + 12)) * (n mod (i + 16)) * (n mod (i + 22)) * (n mod (i + 24)) = 0) then ¬
            return false
    end repeat
    return true
end isPrime

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on intToText(int, separator)
    set groups to {}
    repeat while (int > 999)
        set groups's beginning to ((1000 + (int mod 1000 as integer)) as text)'s text 2 thru 4
        set int to int div 1000
    end repeat
    set groups's beginning to int
    return join(groups, separator)
end intToText

on task()
    set output to {"The first 200 cuban primes are:"}
    set inc to 0
    set candidate to 1
    set counter to 0
    set row to {}
    repeat until (counter = 200)
        set inc to inc + 6
        set candidate to candidate + inc
        if (isPrime(candidate)) then
            set counter to counter + 1
            set end of row to ("           " & intToText(candidate, ","))'s text -11 thru -1
            if ((counter) mod 8 = 0) then
                set end of output to join(row, "")
                set row to {}
            end if
        end if
    end repeat
    repeat until (counter = 100000)
        set inc to inc + 6
        set candidate to candidate + inc
        if (isPrime(candidate)) then set counter to counter + 1
    end repeat
    set end of output to linefeed & "The 100,000th is " & intToText(candidate, ",")
    return join(output, linefeed)
end task

task()
