function median(sequence s)
    atom min,k
    -- Selection sort of half+1
    for i = 1 to length(s)/2+1 do
        min = s[i]
        k = 0
        for j = i+1 to length(s) do
            if s[j] < min then
                min = s[j]
                k = j
            end if
        end for
        if k then
            s[k] = s[i]
            s[i] = min
        end if
    end for
    if remainder(length(s),2) = 0 then
        return (s[$/2]+s[$/2+1])/2
    else
        return s[$/2+1]
    end if
end function

? median({ 4.4, 2.3, -1.7, 7.5, 6.6, 0.0, 1.9, 8.2, 9.3, 4.5 })
