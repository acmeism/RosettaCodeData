load "stdlib.ring"

nhi = [0,9,12,21,12453,738440,45072010,95322020]

for p2 = 1 to len(nhi)
    permut = []
    num2 = nhi[p2]
    nextHighestInt(num2)
next

func nextHighestInt(num)

list = []
numStr = string(num)
lenNum = len(numStr)

if lenNum = 1
   see "" + num + " => " + "0" + nl
   return
ok

for n = 1 to len(numStr)
    p = number(substr(numStr,n,1))
    add(list,p)
next

lenList = len(list)
calmo = []

permut(list)

for n = 1 to len(permut)/lenList
    str = ""
    for m = (n-1)*lenList+1 to n*lenList
        str = str + string(permut[m])
    next
    if str != ""
       strNum = number(str)
       add(calmo,strNum)
    ok
next

for n = len(calmo) to 1 step -1
    lenCalmo = len(string(calmo[n]))
    if lenCalmo < lenNum
       del(calmo,n)
    ok
next

calmo = sort(calmo)

for n = len(calmo) to 2 step -1
    if calmo[n] = calmo[n-1]
       del(calmo,n)
    ok
next

ind = find(calmo,num)
if ind = len(calmo)
   see "" + num + " => " + "0" + nl
else
   see "" + num + " => " + calmo[ind+1] + nl
ok

func permut(list)
     for perm = 1 to factorial(len(list))
         for i = 1 to len(list)
             add(permut,list[i])
         next
         perm(list)
     next

func perm(a)
     elementcount = len(a)
     if elementcount < 1 then return ok
     pos = elementcount-1
     while a[pos] >= a[pos+1]
           pos -= 1
           if pos <= 0 permutationReverse(a, 1, elementcount)
              return ok
     end
     last = elementcount
     while a[last] <= a[pos]
           last -= 1
     end
     temp = a[pos]
     a[pos] = a[last]
     a[last] = temp
     permReverse(a, pos+1, elementcount)

 func permReverse(a,first,last)
      while first < last
            temp = a[first]
            a[first] = a[last]
            a[last] = temp
            first += 1
            last -= 1
      end
