function gnomeSort(sequence s)
    integer i,j
    object temp
    i = 1
    j = 2
    while i < length(s) do
        if compare(s[i], s[i+1]) <= 0 then
            i = j
            j += 1
        else
            temp = s[i]
            s[i] = s[i+1]
            s[i+1] = temp
            i -= 1
            if i = 0 then
                i = j
                j += 1
            end if
        end if
    end while
    return s
end function
