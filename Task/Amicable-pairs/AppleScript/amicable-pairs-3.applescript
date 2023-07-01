on properDivisors(n)
    set output to {}

    if (n > 1) then
        set sqrt to n ^ 0.5
        set limit to sqrt div 1
        if (limit = sqrt) then
            set end of output to limit
            set limit to limit - 1
        end if
        repeat with i from limit to 2 by -1
            if (n mod i is 0) then
                set beginning of output to i
                set end of output to n div i
            end if
        end repeat
        set beginning of output to 1
    end if

    return output
end properDivisors

on sumList(listOfNumbers)
    script o
        property l : listOfNumbers
    end script
    set sum to 0
    repeat with n in o's l
        set sum to sum + n
    end repeat

    return sum
end sumList

on amicablePairsBelow(limitPlus1)
    script o
        property pdSums : {missing value} -- Sums of proper divisors. (Dummy item for 1's.)
    end script
    set limit to limitPlus1 - 1
    repeat with n from 2 to limit
        set end of o's pdSums to sumList(properDivisors(n))
    end repeat

    set output to {}
    repeat with n1 from 2 to (limit - 1)
        set n2 to o's pdSums's item n1
        if ((n1 < n2) and (n2 < limitPlus1) and (o's pdSums's item n2 = n1)) then ¬
            set end of output to {n1, n2}
    end repeat

    return output
end amicablePairsBelow

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to amicablePairsBelow(20000)
    repeat with thisPair in output
        set thisPair's contents to join(thisPair, " & ")
    end repeat
    return join(output, linefeed)
end task

task()
