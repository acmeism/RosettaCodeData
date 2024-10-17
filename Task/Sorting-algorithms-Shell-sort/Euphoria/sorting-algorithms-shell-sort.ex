function shell_sort(sequence s)
    integer gap,j
    object temp
    gap = floor(length(s)/2)
    while gap > 0 do
        for i = gap to length(s) do
            temp = s[i]
            j=i-gap
            while j >= 1 and compare(temp, s[j]) <= 0 do
                s[j+gap]=s[j]
                j -= gap
            end while
            s[j+gap] = temp
        end for
        gap = floor(gap/2)
    end while
    return s
end function

constant s = rand(repeat(1000,10))
puts(1,"Before: ")
? s
puts(1,"After:  ")
? shell_sort(s)
