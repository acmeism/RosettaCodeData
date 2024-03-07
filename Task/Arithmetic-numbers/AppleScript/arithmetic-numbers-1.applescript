on isArithmetic(n)
    if (n < 4) then
        if (n < 0) then return {arithmetic:false, composite:missing value}
        return {arithmetic:(n mod 2 = 1), composite:false}
    end if
    set factorSum to 1 + n
    set factorCount to 2
    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set factorSum to factorSum + limit
        set factorCount to 3
        set limit to limit - 1
    end if
    repeat with i from 2 to limit
        if (n mod i = 0) then
            set factorSum to factorSum + i + n div i
            set factorCount to factorCount + 2
        end if
    end repeat

    return {arithmetic:(factorSum mod factorCount = 0), composite:(factorCount > 2)}
end isArithmetic

on task()
    set output to {linefeed & "The first 100 arithmetic numbers are:"}
    set {n, hitCount, compositeCount, pad} to {0, 0, 0, "   "}
    repeat 10 times
        set row to {}
        set targetCount to hitCount + 10
        repeat until (hitCount = targetCount)
            set n to n + 1
            tell isArithmetic(n) to if (its arithmetic) then
                set hitCount to hitCount + 1
                if (its composite) then set compositeCount to compositeCount + 1
                set row's end to text -4 thru -1 of (pad & n)
            end if
        end repeat
        set output's end to join(row, "")
    end repeat
    repeat with targetCount in {1000, 10000, 100000, 1000000}
        repeat while (hitCount < targetCount)
            set n to n + 1
            tell isArithmetic(n) to if (its arithmetic) then
                set hitCount to hitCount + 1
                if (its composite) then set compositeCount to compositeCount + 1
            end if
        end repeat
        set output's end to (linefeed & "The " & targetCount & "th arithmetic number is " & n) & ¬
            (linefeed & "(" & compositeCount & " composite numbers up to here)")
    end repeat

    return join(output, linefeed)
end task

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

task()
