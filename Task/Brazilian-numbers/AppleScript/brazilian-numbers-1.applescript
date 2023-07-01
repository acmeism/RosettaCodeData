on isBrazilian(n)
    repeat with b from 2 to n - 2
        set d to n mod b
        set temp to n div b
        repeat while (temp mod b = d) -- ((temp > 0) and (temp mod b = d))
            set temp to temp div b
        end repeat
        if (temp = 0) then return true
    end repeat

    return false
end isBrazilian

on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat

    return true
end isPrime

-- Task code:
on runTask()
    set output to {}
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "  "

    set collector to {}
    set n to 1
    repeat until ((count collector) is 20)
        if (isBrazilian(n)) then set end of collector to n
        set n to n + 1
    end repeat
    set end of output to "First 20 Brazilian numbers:  " & linefeed & collector

    set collector to {}
    set n to 1
    repeat until ((count collector) is 20)
        if (isBrazilian(n)) then set end of collector to n
        set n to n + 2
    end repeat
    set end of output to "First 20 odd Brazilian numbers:  " & linefeed & collector

    set collector to {}
    if (isBrazilian(2)) then set end of collector to 2
    set n to 3
    repeat until ((count collector) is 20)
        if (isPrime(n)) and (isBrazilian(n)) then set end of collector to n
        set n to n + 2
    end repeat
    set end of output to "First 20 prime Brazilian numbers:  " & linefeed & collector

    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid
    return output
end runTask

return runTask()
