function bubble_sort(sequence s)
    object tmp
    integer changed
    for j = length(s) to 1 by -1 do
        changed = 0
        for i = 1 to j-1 do
            if compare(s[i], s[i+1]) > 0 then
                tmp = s[i]
                s[i] = s[i+1]
                s[i+1] = tmp
                changed = 1
            end if
        end for
        if not changed then
            exit
        end if
    end for
    return s
end function

include misc.e
constant s = {4, 15, "delta", 2, -31, 0, "alfa", 19, "gamma", 2, 13, "beta", 782, 1}

puts(1,"Before: ")
pretty_print(1,s,{2})
puts(1,"\nAfter: ")
pretty_print(1,bubble_sort(s),{2})
