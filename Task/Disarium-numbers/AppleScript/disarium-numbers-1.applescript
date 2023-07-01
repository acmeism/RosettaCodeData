on isDisarium(n)
    set temp to n
    set digitCount to 1
    repeat while (temp > 9)
        set temp to temp div 10
        set digitCount to digitCount + 1
    end repeat
    set temp to n
    set sum to 0
    repeat with position from digitCount to 2 by -1
        set sum to sum + (temp mod 10) ^ position
        set temp to temp div 10
    end repeat

    return (sum + temp = n)
end isDisarium

local Disaria, n
set Disaria to {}
set n to 0
repeat until ((count Disaria) = 19)
    if (isDisarium(n)) then set end of Disaria to n
    set n to n + 1
end repeat

return Disaria
