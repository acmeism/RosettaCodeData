function map_range(sequence a, sequence b, atom s)
    return b[1]+(s-a[1])*(b[2]-b[1])/(a[2]-a[1])
end function

for i = 0 to 10 do
    printf(1, "%2g maps to %4g\n", {i, map_range({0,10},{-1,0},i)})
end for
