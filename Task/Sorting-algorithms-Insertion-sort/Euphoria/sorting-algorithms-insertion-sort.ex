function insertion_sort(sequence s)
    object temp
    integer j
    for i = 2 to length(s) do
        temp = s[i]
        j = i-1
        while j >= 1 and compare(s[j],temp) > 0 do
            s[j+1] = s[j]
            j -= 1
        end while
        s[j+1] = temp
    end for
    return s
end function

include misc.e
constant s = {4, 15, "delta", 2, -31, 0, "alfa", 19, "gamma", 2, 13, "beta", 782, 1}

puts(1,"Before: ")
pretty_print(1,s,{2})
puts(1,"\nAfter: ")
pretty_print(1,insertion_sort(s),{2})
