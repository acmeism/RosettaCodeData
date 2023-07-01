on babbage(endDigits)
    -- Set up an incrementor to the amount in front of the given end digits.
    if (endDigits's class is text) then
        set increment to 10 ^ (count endDigits) div 1
    else
        set increment to 10
        repeat until (increment > endDigits)
            set increment to increment * 10
        end repeat
    end if
    -- I postulate that if no square ending with the given digits is found with less than
    -- twice that many digits, then no such square exists; but I can't be certain.  :)
    set limit to increment * (increment div 10)
    -- In any case, AppleScript's precision limit is 1.0E+15.
    if (limit > 1.0E+15) then return missing value
    -- Test successive values ending with the digits until one is found
    -- to have an integer square root or the limit is exceeded.
    set testNumber to endDigits div 1
    set squareRoot to testNumber ^ 0.5
    repeat until ((squareRoot mod 1 = 0) or (testNumber > limit))
        set testNumber to testNumber + increment
        set squareRoot to testNumber ^ 0.5
    end repeat

    if (testNumber > limit) then return missing value -- No such square.
    return {squareRoot as integer, testNumber} -- {integer, square ending with the digits}
end babbage

return {babbage(269696), babbage("00609")}
