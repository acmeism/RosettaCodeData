decimals(7)
s = [4,3,4,2,1,1,2,3,4,5]

for i = 10 to 1 step -1
    see "f(" + s[i] + ")=";
    x = f(s[i])
    if x > 400 see "--- too large ---" + nl
    else see x + nl ok
next

func f n
     return sqrt(fabs(n))+5*pow(n,3)
