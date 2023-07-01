function flip(sequence s, integer n)
    object temp
    for i = 1 to n/2 do
        temp = s[i]
        s[i] = s[n-i+1]
        s[n-i+1] = temp
    end for
    return s
end function

function pancake_sort(sequence s)
    integer m
    for i = length(s) to 2 by -1 do
        m = 1
        for j = 2 to i do
            if compare(s[j], s[m]) > 0 then
                m = j
            end if
        end for

        if m < i then
            if m > 1 then
                s = flip(s,m)
            end if
            s = flip(s,i)
        end if
    end for
    return s
end function

constant s = rand(repeat(100,10))

? s
? pancake_sort(s)
