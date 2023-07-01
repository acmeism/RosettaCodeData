load "stdlib.ring"

see "working..." + nl
see "The first 220 Zumkeller numbers are:" + nl

permut = []
zumind = []
zumodd = []
limit = 19305
num1 = 0
num2 = 0

for n = 2 to limit
    zumkeller = []
    zumList = []
    permut = []
    calmo = []
    zumind = []
    num = 0
    nold = 0
    for m = 1 to n
        if n % m = 0
           num = num + 1
           add(zumind,m)
        ok
    next
    for p = 1 to num
        add(zumList,1)
        add(zumList,2)
    next
    permut(zumList)
    lenZum = len(zumList)

    for n2 = 1 to len(permut)/lenZum
        str = ""
        for m = (n2-1)*lenZum+1 to n2*lenZum
            str = str + string(permut[m])
        next
        if str != ""
           strNum = number(str)
           add(calmo,strNum)
        ok
    next

    calmo = sort(calmo)

    for x = len(calmo) to 2 step -1
        if calmo[x] = calmo[x-1]
           del(calmo,x)
        ok
    next

    zumkeller = []
    calmoLen = len(string(calmo[1]))
    calmoLen2 = calmoLen/2
    for y = 1 to len(calmo)
        tmpStr = string(calmo[y])
        tmp1 = left(tmpStr,calmoLen2)
        tmp2 = number(tmp1)
        add(zumkeller,tmp2)
    next

    zumkeller = sort(zumkeller)

    for x = len(zumkeller) to 2 step -1
        if zumkeller[x] = zumkeller[x-1]
           del(zumkeller,x)
        ok
    next

    for z = 1 to len(zumkeller)
        zumsum1 = 0
        zumsum2 = 0
        zum1 = []
        zum2 = []

        for m = 1 to len(string(zumkeller[z]))
            zumstr = string(zumkeller[z])
            tmp = number(zumstr[m])
            if tmp = 1
               add(zum1,zumind[m])
            else
               add(zum2,zumind[m])
            ok
        next

        for z1 = 1 to len(zum1)
            zumsum1 = zumsum1 + zum1[z1]
        next

        for z2 = 1 to len(zum2)
            zumsum2 = zumsum2 + zum2[z2]
        next

        if zumsum1 = zumsum2
           num1 = num1 + 1
           if n != nold
              if num1 < 221
                 if (n-1)%22 = 0
                    see nl + " " + n
                 else
                    see " " + n
                 ok
              ok
              if zumsum1%2 = 1
                 num2 = num2 + 1
                 if num2 < 41
                    add(zumodd,n)
                 ok
              ok
           ok
           nold = n
        ok
    next
next

see "The first 40 odd Zumkeller numbers are:" + nl
for n = 1 to len(zumodd)
    if (n-1)%8 = 0
       see nl + " " + zumodd[n]
    else
       see " " + zumodd[n]
    ok
next

see nl + "done..." + nl

func permut(list)
     for perm = 1 to factorial(len(list))
         for i = 1 to len(list)
             add(permut,list[i])
         next
         perm(list)
     next

func perm(a)
     elementcount = len(a)
     if elementcount < 1
        return
     ok
     pos = elementcount-1
     while a[pos] >= a[pos+1]
           pos -= 1
           if pos <= 0 permutationReverse(a, 1, elementcount)
              return
           ok
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
