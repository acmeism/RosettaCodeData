function arithmetic_mean(sequence s)
    atom sum
    if length(s) = 0 then
        return 0
    else
        sum = 0
        for i = 1 to length(s) do
            sum += s[i]
        end for
        return sum/length(s)
    end if
end function

function geometric_mean(sequence s)
    atom p
    p = 1
    for i = 1 to length(s) do
        p *= s[i]
    end for
    return power(p,1/length(s))
end function

function harmonic_mean(sequence s)
    atom sum
    if length(s) = 0 then
        return 0
    else
        sum = 0
        for i = 1 to length(s) do
            sum += 1/s[i]
        end for
        return length(s) / sum
    end if
end function

function true_or_false(atom x)
    if x then
        return "true"
    else
        return "false"
    end if
end function

constant s = {1,2,3,4,5,6,7,8,9,10}
constant arithmetic = arithmetic_mean(s),
    geometric = geometric_mean(s),
    harmonic = harmonic_mean(s)
printf(1,"Arithmetic: %g\n", arithmetic)
printf(1,"Geometric: %g\n", geometric)
printf(1,"Harmonic: %g\n", harmonic)
printf(1,"Arithmetic>=Geometric>=Harmonic: %s\n",
    {true_or_false(arithmetic>=geometric and geometric>=harmonic)})
