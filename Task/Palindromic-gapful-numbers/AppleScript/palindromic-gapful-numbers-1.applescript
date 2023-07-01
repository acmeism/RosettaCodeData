on doTask()
    set part1 to {"First 20 palindromic gapful numbers > 100 ending with each digit from 1 to 9:"}
    set part2 to {"86th to 100th such:"}
    set part3 to {"991st to 1000th:"}
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "  "
    repeat with endDigit from 1 to 9
        set {collector1, collector2, collector3} to {{}, {}, {}}
        set outerNumber to endDigit * 11 -- Number formed from the palindromes' first and last digits.
        set oddDigitCount to true -- Starting with palindromes in the hundreds.
        set baseHi to endDigit * 10 -- Number formed from just the "high end" digits, initially endDigit and a middle 0.
        set hi to baseHi
        set carryCheck to hi + 10 -- Number reached when incrementing the "high end" number changes its first digit.
        set inc to 10 -- Incrementor for the middle digit(s) of the palindromes themselves.
        set counter to 0
        set maxNeeded to 1000
        set done to false
        repeat until (done)
            -- Work out every 10th palindrome (middle digit = 0) from the current "high end" number.
            set pal to hi
            if (oddDigitCount) then
                set temp to hi div 10
            else
                set temp to hi
            end if
            repeat until (temp is 0)
                set pal to pal * 10 + temp mod 10
                set temp to temp div 10
            end repeat
            -- Check the result and the following 9 palindromes (derived by incrementing the middle digit(s))
            -- and store as text any which are both gapful and the ones required.
            repeat 10 times
                if (pal mod outerNumber is 0) then
                    set counter to counter + 1
                    if (counter ≤ 20) then
                        set end of collector1 to intText(pal)
                    else if (counter < 86) then
                    else if (counter ≤ 100) then
                        set end of collector2 to intText(pal)
                    else if (counter < 991) then
                    else --if (counter ≤ 1000) then
                        set end of collector3 to intText(pal)
                        set done to (counter = maxNeeded)
                        if (done) then exit repeat
                    end if
                end if
                set pal to pal + inc
            end repeat
            -- Increment the high end number's penultimate digit after every 10th palindrome.
            -- If a carry changes its first digit, reset for longer palindromes.
            set hi to hi + 10
            if (hi = carryCheck) then
                set oddDigitCount to (not oddDigitCount)
                if (oddDigitCount) then
                    set baseHi to baseHi * 10
                    set carryCheck to carryCheck * 10
                    set inc to inc div 11 * 10
                else
                    set inc to inc * 11
                end if
                set hi to baseHi
            end if
        end repeat
        set {end of part1, end of part2, end of part3} to {collector1 as text, collector2 as text, collector3 as text}
    end repeat
    set AppleScript's text item delimiters to linefeed
    set output to {part1, "", part2, "", part3} as text
    set AppleScript's text item delimiters to astid

    return output
end doTask

on intText(n)
    if (n < 100000000) then return n as text
    set txt to text 2 thru end of ((100000000 + (n mod 100000000 as integer)) as text)
    set n to n div 100000000
    repeat
        set lo to n mod 100000000 as integer
        set n to n div 100000000
        if (n is 0) then return (lo as text) & txt
        set txt to (text 2 thru end of ((100000000 + lo) as text)) & txt
    end repeat
end intText

return doTask()
