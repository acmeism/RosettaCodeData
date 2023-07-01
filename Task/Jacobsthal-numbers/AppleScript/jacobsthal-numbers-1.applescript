on jacobsthalNumbers(variant, n)
    -- variant: text containing "Lucas", "oblong", or "prime" — or none of these.
    -- n: length of output sequence required.

    -- The two Jacobsthal numbers preceding the current 'j'. Initially the first two in the sequence.
    set {anteprev, prev} to {0, 1}
    -- Default plug-in script. Its handler simply appends the current 'j' to the output.
    script o
        property output : {anteprev, prev}
        on append(dummy, j)
            set end of output to j
        end append
    end script

    -- If a variant sequence is specified, change the first value or substitute
    -- a script whose handler decides the values to append to the output.
    ignoring case
        if (variant contains "Lucas") then
            set anteprev to 2
            set o's output's first item to anteprev
        else if (variant contains "oblong") then
            script
                property output : {0}
                on append(prev, j)
                    set end of output to prev * j
                end append
            end script
            set o to result
        else if (variant contains "prime") then
            script
                property output : {}
                on append(dummy, j)
                    if (isPrime(j)) then set end of output to j
                end append
            end script
            set o to result
        end if
    end ignoring

    -- Work through the Jacobsthal process until the required output length is obtained.
    repeat until ((count o's output) = n)
        set j to anteprev + anteprev + prev
        tell o to append(prev, j)
        set anteprev to prev
        set prev to j
    end repeat

    return o's output
end jacobsthalNumbers

on isPrime(n)
    if (n < 3) then return (n is 2)
    if (n mod 2 is 0) then return false
    repeat with i from 3 to (n ^ 0.5) div 1 by 2
        if (n mod i is 0) then return false
    end repeat
    return true
end isPrime

-- Task and presentation of results!:
on intToText(n)
    set txt to ""
    repeat until (n < 100000000)
        set txt to text 2 thru 9 of (100000000 + (n mod 100000000) div 1 as text) & txt
        set n to n div 100000000
    end repeat
    return (n as integer as text) & txt
end intToText

on chopList(theList, sublistLen)
    script o
        property lst : theList
        property output : {}
    end script

    set listLen to (count o's lst)
    repeat with i from 1 to listLen by sublistLen
        set j to i + sublistLen - 1
        if (j > listLen) then set j to listLen
        set end of o's output to items i thru j of o's lst
    end repeat
    return o's output
end chopList

on matrixToText(matrix, w)
    script o
        property matrix : missing value
        property row : missing value
    end script

    set o's matrix to matrix
    set padding to "                   "
    repeat with r from 1 to (count o's matrix)
        set o's row to o's matrix's item r
        repeat with i from 1 to (count o's row)
            set o's row's item i to text -w thru end of (padding & o's row's item i)
        end repeat
        set o's matrix's item r to join(o's row, "")
    end repeat

    return join(o's matrix, linefeed)
end matrixToText

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to {"First 30 Jacobsthal Numbers:", "First 30 Jacobsthal-Lucas Numbers:", ¬
        "First 20 Jacobsthal oblong Numbers:", "First 11 Jacobsthal Primes:"}
    set results to {jacobsthalNumbers("", 30), jacobsthalNumbers("Lucas", 30), ¬
        jacobsthalNumbers("oblong", 20), jacobsthalNumbers("prime", 11)}
    repeat with i from 1 to 4
        set thisSequence to item i of results
        repeat with j in thisSequence
            set j's contents to intToText(j)
        end repeat
        if (i < 4) then
            set theLines to chopList(thisSequence, 10)
        else
            set theLines to chopList(thisSequence, 6)
        end if
        set item i of output to item i of output & linefeed & matrixToText(theLines, (count end of thisSequence) + 1)
    end repeat

    return join(output, linefeed & linefeed)
end task

task()
