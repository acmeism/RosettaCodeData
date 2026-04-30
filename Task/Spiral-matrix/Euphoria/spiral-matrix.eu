function spiral(integer dimension)
    integer side, curr, curr2
    sequence s
    s = repeat(repeat(0,dimension),dimension)
    side = dimension
    curr = 0
    for i = 0 to floor(dimension/2) do
        for j = 1 to side-1 do
            s[i+1][i+j] = curr -- top
            curr2 = curr + side-1
            s[i+j][i+side] = curr2 -- right
            curr2 += side-1
            s[i+side][i+side-j+1] = curr2 -- bottom
            curr2 += side-1
            s[i+side-j+1][i+1] = curr2 -- left
            curr += 1
        end for
        curr = curr2 + 1
        side -= 2
    end for

    if remainder(dimension,2) then
        s[floor(dimension/2)+1][floor(dimension/2)+1] = curr
    end if

    return s
end function

? spiral(5)
