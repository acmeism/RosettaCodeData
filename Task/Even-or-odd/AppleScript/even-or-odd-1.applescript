set L to {3, 2, 1, 0, -1, -2, -3}

set evens to {}
set odds to {}

repeat with x in L
    if (x mod 2 = 0) then
        set the end of evens to x's contents
    else
        set the end of odds to x's contents
    end if
end repeat

return {even:evens, odd:odds}
