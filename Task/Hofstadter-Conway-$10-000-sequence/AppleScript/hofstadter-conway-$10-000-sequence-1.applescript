on HC10000(ceiling)
    script o
        property lst : {1, 1}
        property maxima : {}
    end script

    set p to missing value
    set max to 0
    set maxPos to 0
    set power to 0
    set x to end of o's lst
    repeat with n from 3 to ceiling
        set x to (item x of o's lst) + (item -x of o's lst)
        set end of o's lst to x
        set ann to x / n
        if (ann is not less than 0.55) then set p to n
        if (ann > max) then
            set max to ann
            set maxPos to n
        end if
        if (ann is 0.5) then
            set power to power + 1
            set end of o's maxima to {|<-powers->|:{power, power + 1}, n:maxPos, max:max}
            set max to 0
        end if
    end repeat

    return {p:p, maxima:o's maxima}
end HC10000

HC10000(2 ^ 20)
