on nextHarshad(n)
    if (n < 0) then set n to 0
    repeat
        set n to n + 1
        set temp to n
        set sum to 0
        repeat until (temp is 0)
            set sum to sum + temp mod 10
            set temp to temp div 10
        end repeat
        if (n mod sum is 0) then return n
    end repeat
end nextHarshad

-- Test code:
set harshads to {}
set h to 0
repeat 20 times
    set h to nextHarshad(h)
    set end of harshads to h
end repeat

set h to nextHarshad(1000)

return {harshads, h}
