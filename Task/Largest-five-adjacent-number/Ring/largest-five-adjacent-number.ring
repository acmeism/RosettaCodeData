digit = ""
max = 0
min = 99999
limit = 1000

for n = 1 to limit
    rand = random(9)
    randStr = string(rand)
    digit += randStr
next

for n = 1 to len(digit)-5
    res = substr(digit,n,5)
    resNum = number(res)
    if resNum > max
       max = resNum
    ok
    if resNum < min
       min = res
    ok
next

see "The largest number is:" + nl
see max + nl
see "The smallest number is:" + nl
see min + nl
