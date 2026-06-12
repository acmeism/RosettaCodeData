? "working..."

Num1 = [ 5,45,23,21,67]
Num2 = [43,22,78,46,38]
Num3 = [ 9,98,12,54,53]
n = len(Num1)
Nums = list(n)

for i = 1 to n
    Nums[i] = nxtPrime(max([Num1[i], Num2[i], Num3[i]]))
next

? "The minimum prime numbers of three lists = " + fmtArray(Nums)
put "done..."

func fmtArray(ar)
    rv = ar[1]
    for n = 2 to len(ar) rv += "," + ar[n] next
    return "[" + rv + "]"

func nxtPrime(x)
    j = 2
    while true
        if x % j = 0 j = 2 x++
        else j++ ok
        if j * j > x exit ok
    end return string(x)
