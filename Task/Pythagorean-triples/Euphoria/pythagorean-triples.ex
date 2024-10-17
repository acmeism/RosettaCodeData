function tri(atom lim, sequence in)
    sequence r
    atom p
    p = in[1] + in[2] + in[3]
    if p > lim then
        return {0, 0}
    end if
    r = {1, floor(lim / p)}
    r += tri(lim, { in[1]-2*in[2]+2*in[3],  2*in[1]-in[2]+2*in[3],  2*in[1]-2*in[2]+3*in[3]})
    r += tri(lim, { in[1]+2*in[2]+2*in[3],  2*in[1]+in[2]+2*in[3],  2*in[1]+2*in[2]+3*in[3]})
    r += tri(lim, {-in[1]+2*in[2]+2*in[3], -2*in[1]+in[2]+2*in[3], -2*in[1]+2*in[2]+3*in[3]})
    return r
end function

atom max_peri
max_peri = 10
while max_peri <= 100000000 do
    printf(1,"%d: ", max_peri)
    ? tri(max_peri, {3, 4, 5})
    max_peri *= 10
end while
