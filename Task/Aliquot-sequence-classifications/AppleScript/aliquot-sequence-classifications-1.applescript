on aliquotSum(n)
    if (n < 2) then return 0
    set sum to 1
    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set sum to sum + limit
        set limit to limit - 1
    end if
    repeat with i from 2 to limit
        if (n mod i is 0) then set sum to sum + i + n div i
    end repeat

    return sum
end aliquotSum

on aliquotSequence(k, maxLength, maxN)
    -- Generate the sequence within the specified limitations.
    set sequence to {k}
    set n to k
    repeat (maxLength - 1) times
        set n to aliquotSum(n)
        set repetition to (sequence contains n)
        if (repetition) then exit repeat
        set end of sequence to n
        if ((n = 0) or (n > maxN)) then exit repeat
    end repeat
    -- Analyse it.
    set sequenceLength to (count sequence)
    if (sequenceLength is 1) then
        set classification to "perfect"
    else if (n is 0) then
        set classification to "terminating"
    else if (n = k) then
        if (sequenceLength is 2) then
            set classification to "amicable"
        else
            set classification to "sociable"
        end if
    else if (repetition) then
        if (sequence ends with n) then
            set classification to "aspiring"
        else
            set classification to "cyclic"
        end if
    else
        set classification to "non-terminating"
    end if

    return {sequence:sequence, classification:classification}
end aliquotSequence

-- Task code:
local output, maxLength, maxN, spacing, astid, k
set output to {""}
set {maxLength, maxN} to {16, 2 ^ 47}
set spacing to "                    "
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ", "
repeat with k in {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, ¬
    11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488, 1.535571778608E+13}
    set thisResult to aliquotSequence(k's contents, maxLength, maxN)
    set end of output to text -18 thru -1 of (spacing & k) & ":  " & ¬
        text 1 thru 17 of (thisResult's classification & spacing) & thisResult's sequence
end repeat
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
