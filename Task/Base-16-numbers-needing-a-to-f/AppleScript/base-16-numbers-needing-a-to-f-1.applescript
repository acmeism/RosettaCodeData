local output, n, x, ding
set output to {}
repeat with n from 0 to 500
    set x to n
    set ding to (x mod 16 > 9)
    repeat until ((x < 10) or (ding))
        set x to x div 16
        set ding to (x mod 16 > 9)
    end repeat
    if (ding) then set end of output to n
end repeat
return output
