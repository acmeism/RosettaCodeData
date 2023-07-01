function transpose(sequence in)
    sequence out
    out = repeat(repeat(0,length(in)),length(in[1]))
    for n = 1 to length(in) do
        for m = 1 to length(in[1]) do
            out[m][n] = in[n][m]
        end for
    end for
    return out
end function

sequence m
m = {
  {1,2,3,4},
  {5,6,7,8},
  {9,10,11,12}
}

? transpose(m)
