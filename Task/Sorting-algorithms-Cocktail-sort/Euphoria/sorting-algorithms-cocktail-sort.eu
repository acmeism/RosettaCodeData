function cocktail_sort(sequence s)
    integer swapped, d
    object temp
    sequence fromto
    fromto = {1,length(s)-1}
    swapped = 1
    d = 1
    while swapped do
        swapped = 0
        for i = fromto[(1-d)/2+1] to fromto[(1+d)/2+1] by d do
            if compare(s[i],s[i+1])>0 then
                temp = s[i]
                s[i] = s[i+1]
                s[i+1] = temp
                swapped = 1
            end if
        end for
        d = -d
    end while
    return s
end function

constant s = rand(repeat(1000,10))
? s
? cocktail_sort(s)
