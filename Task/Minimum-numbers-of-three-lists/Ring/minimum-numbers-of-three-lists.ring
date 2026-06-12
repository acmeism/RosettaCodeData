see "? "working..."

Num1 = [ 5,45,23,21,67]
Num2 = [43,22,78,46,38]
Num3 = [ 9,98,12,98,53]
n = len(Num1)
Nums = list(n)

for i = 1 to n
    Nums[i] = string(min([Num1[i], Num2[i], Num3[i]]))
next

? "The minimum numbers of three lists = " + fmtArray(Nums)
put "done..."

func fmtArray(ar)
    rv = ar[1]
    for n = 2 to len(ar) rv += "," + ar[n] next
    return "[" + rv + "]"
