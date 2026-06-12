on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat

    return true
end isPrime

on primeFactors(n)
    if (isPrime(n)) then return {n}
    set output to {}
    set sqrt to n ^ 0.5
    if ((sqrt = sqrt div 1) and (isPrime(sqrt))) then
        set end of output to sqrt div 1
        set sqrt to sqrt - 1
    end if
    repeat with i from (sqrt div 1) to 2 by -1
        if (n mod i is 0) then
            if (isPrime(i)) then set beginning of output to i
            if (isPrime(n div i)) then set end of output to n div i
        end if
    end repeat

    return output
end primeFactors

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to {""}
    set thisLine to {"     1"}
    repeat with n from 2 to 100
        tell primeFactors(n) to set product to (its end) * (its beginning)
        set end of thisLine to text -6 thru end of ("     " & product)
        if (n mod 10 is 0) then
            set end of output to join(thisLine, "")
            set thisLine to {}
        end if
    end repeat
    return join(output, linefeed)
end task

task()
