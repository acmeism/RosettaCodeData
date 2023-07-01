on fusc(n)
    if (n < 2) then
        return n
    else if (n mod 2 is 0) then
        return fusc(n div 2)
    else
        return fusc((n - 1) div 2) + fusc((n + 1) div 2)
    end if
end fusc

set sequence to {}
set longestSoFar to 0
repeat with i from 0 to 60
    set fuscNumber to fusc(i)
    set end of sequence to fuscNumber
    set len to (count (fuscNumber as text))
    if (len > longestSoFar) then
        set longestSoFar to len
        set firstLongest to fuscNumber
        set indexThereof to i + 1 -- AppleScript indices are 1-based.
    end if
end repeat

return {sequence:sequence, firstLongest:firstLongest, indexThereof:indexThereof}
