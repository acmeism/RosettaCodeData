on hcf(a, b)
    repeat until (b = 0)
        set x to a
        set a to b
        set b to x mod b
    end repeat

    if (a < 0) then return -a
    return a
end hcf

local input, coprimes, thisPair, p, q
set input to {{21, 15}, {17, 23}, {36, 12}, {18, 29}, {60, 15}}
set coprimes to {}
repeat with thisPair in input
    set {p, q} to thisPair
    if (hcf(p, q) is 1) then set end of coprimes to thisPair's contents
end repeat
return coprimes
