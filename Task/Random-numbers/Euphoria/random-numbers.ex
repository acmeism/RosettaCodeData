include misc.e

function RandomNormal()
    atom x1, x2
    x1 = rand(999999) / 1000000
    x2 = rand(999999) / 1000000
    return sqrt(-2*log(x1)) * cos(2*PI*x2)
end function

constant n = 1000
sequence s
s = repeat(0,n)
for i = 1 to n do
    s[i] = 1 + 0.5 * RandomNormal()
end for
