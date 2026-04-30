function matrix_mul(sequence a, sequence b)
    sequence c
    if length(a[1]) != length(b) then
        return 0
    else
        c = repeat(repeat(0,length(b[1])),length(a))
        for i = 1 to length(a) do
            for j = 1 to length(b[1]) do
                for k = 1 to length(a[1]) do
                    c[i][j] += a[i][k]*b[k][j]
                end for
            end for
        end for
        return c
    end if
end function
