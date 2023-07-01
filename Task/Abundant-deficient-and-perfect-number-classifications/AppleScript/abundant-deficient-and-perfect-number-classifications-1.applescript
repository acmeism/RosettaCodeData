on aliquotSum(n)
    if (n < 2) then return 0
    set sum to 1
    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set sum to sum + limit
        set limit to limit - 1
    end if
    repeat with i from 2 to limit
        if (n mod i is 0) then set sum to sum + i + n div i
    end repeat

    return sum
end aliquotSum

on task()
    set {deficient, perfect, abundant} to {0, 0, 0}
    repeat with n from 1 to 20000
        set s to aliquotSum(n)
        if (s < n) then
            set deficient to deficient + 1
        else if (s > n) then
            set abundant to abundant + 1
        else
            set perfect to perfect + 1
        end if
    end repeat

    return {deficient:deficient, perfect:perfect, abundant:abundant}
end task

task()
