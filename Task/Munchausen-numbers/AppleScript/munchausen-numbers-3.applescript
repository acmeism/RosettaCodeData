set MunchhausenNumbers to {}
repeat with i from 1 to 5000
    if (i > 0) then
        set n to i
        set s to 0
        repeat until (n is 0)
            tell n mod 10 to set s to s + it ^ it
            set n to n div 10
        end repeat
        if (s = i) then set end of MunchhausenNumbers to i
    end if
end repeat

return MunchhausenNumbers
