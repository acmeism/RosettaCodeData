function stooge(sequence s, integer i, integer j)
    object temp
    integer t
    if compare(s[j], s[i]) < 0 then
        temp = s[i]
        s[i] = s[j]
        s[j] = temp
    end if
    if j - i > 1 then
        t = floor((j - i + 1)/3)
        s = stooge(s, i  , j-t)
        s = stooge(s, i+t, j  )
        s = stooge(s, i  , j-t)
    end if
    return s
end function

function stoogesort(sequence s)
    return stooge(s,1,length(s))
end function

constant s = rand(repeat(1000,10))

? s
? stoogesort(s)
