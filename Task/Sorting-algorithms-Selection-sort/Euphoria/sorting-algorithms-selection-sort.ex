function selection_sort(sequence s)
    object tmp
    integer m
    for i = 1 to length(s) do
        m = i
        for j = i+1 to length(s) do
            if compare(s[j],s[m]) < 0 then
                m = j
            end if
        end for
        tmp = s[i]
        s[i] = s[m]
        s[m] = tmp
    end for
    return s
end function

include misc.e
constant s = {4, 15, "delta", 2, -31, 0, "alfa", 19, "gamma", 2, 13, "beta", 782, 1}

puts(1,"Before: ")
pretty_print(1,s,{2})
puts(1,"\nAfter: ")
pretty_print(1,selection_sort(s),{2})
