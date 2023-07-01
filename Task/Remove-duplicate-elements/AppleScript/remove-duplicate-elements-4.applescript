unique({1, 2, 3, "a", "b", "c", 2, 3, 4, "c", {b:"c"}, {"c"}, "c", "d"})

on unique(x)
    set R to {}
    repeat with i in x
        set i to i's contents
        if {i} is not in R then set end of R to i
    end repeat
    return R
end unique
