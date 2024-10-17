function dotprod(sequence a, sequence b)
    atom sum
    a *= b
    sum = 0
    for n = 1 to length(a) do
        sum += a[n]
    end for
    return sum
end function

? dotprod({1,3,-5},{4,-2,-1})
