on hcf(a, b)
    repeat until (b = 0)
        set x to a
        set a to b
        set b to x mod b
    end repeat

    if (a < 0) then return -a
    return a
end hcf
