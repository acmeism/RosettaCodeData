function zigzag(integer size)
    sequence s
    integer i, j, d, max
    s = repeat(repeat(0,size),size)
    i = 1  j = 1  d = -1
    max = size*size
    for n = 1 to floor(max/2)+1 do
        s[i][j] = n
        s[size-i+1][size-j+1] = max-n+1
        i += d  j-= d
        if i < 1 then
            i += 1  d = -d
        elsif j < 1 then
            j += 1  d = -d
        end if
    end for
    return s
end function

? zigzag(5)
