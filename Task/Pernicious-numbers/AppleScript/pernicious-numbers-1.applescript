on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat

    return true
end isPrime

on isPernicious(n)
    -- 8 bits at a time is statistically slightly more efficient than 1 bit at a time.
    set popCount to (n mod 4 + 1) div 2 + (n mod 16 + 4) div 8
    set n to n div 16
    repeat until (n = 0)
        set popCount to popCount + (n mod 4 + 1) div 2 + (n mod 16 + 4) div 8
        set n to n div 16
    end repeat

    return isPrime(popCount)
end isPernicious

-- Task code:
on intToText(n)
    set output to ""
    repeat until (n < 100000000)
        set output to text 2 thru 9 of ((100000000 + (n mod 100000000 as integer)) as text) & output
        set n to n div 100000000
    end repeat
    set output to (n as integer as text) & output

    return output
end intToText

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set output to lst as text
    set AppleScript's text item delimiters to astid

    return output
end join

on task()
    set l1 to {}
    set n to 0
    set counter to 0
    repeat until (counter = 25)
        if (isPernicious(n)) then
            set end of l1 to n
            set counter to counter + 1
        end if
        set n to n + 1
    end repeat

    set l2 to {}
    -- One solution to 8,888,877 and up being too large to be AppleScript repeat indices.
    repeat with i from 88888877 to 88888888
        set n to 8.0E+8 + i
        if (isPernicious(n)) then set end of l2 to intToText(n)
    end repeat

    return join(l1, "  ") & (linefeed & join(l2, "  "))
end task

task()
