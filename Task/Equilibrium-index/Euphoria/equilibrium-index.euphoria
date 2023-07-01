function equilibrium(sequence s)
    integer lower_sum, higher_sum
    sequence indices
    lower_sum = 0
    higher_sum = 0
    for i = 1 to length(s) do
        higher_sum += s[i]
    end for
    indices = {}
    for i = 1 to length(s) do
        higher_sum -= s[i]
        if lower_sum = higher_sum then
            indices &= i
        end if
        lower_sum += s[i]
    end for
    return indices
end function

? equilibrium({-7,1,5,2,-4,3,0})
