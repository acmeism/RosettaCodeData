basePlus = []
decList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
baseList = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]

for base = 2 to 16
    see "Base " + base + ": " + (base*4) + "th to " + (base*6) + "th esthetic numbers:" + nl
    res = 0
    binList = []
for n = 1 to 10000
    str = decimaltobase(n,base)
    limit1 = base*4
    limit2 = base*6
    ln = len(str)
    flag = 0
    for m = 1 to ln-1
        nr1 = str[m]
        ind1 = find(baseList,nr1)
        num1 = decList[ind1]
        nr2 = str[m+1]
        ind2 = find(baseList,nr2)
        num2 = decList[ind2]
        num = num1-num2
        if num = 1 or num = -1
           flag = flag + 1
        ok
     next
     if flag = ln - 1
        res = res + 1
        if res > (limit1 - 1) and res < (limit2 + 1)
           see " " + str
        ok
        if base = 10 and number(str) > 1000 and number(str) < 9999
           add(basePlus,str)
        ok
     ok
next
see nl + nl
next

see "Base 10: " + len(basePlus) +" esthetic numbers between 1000 and 9999:"

for row = 1 to len(basePlus)
    if (row-1) % 16 = 0
       see nl
    else
       see " " + basePlus[row]
    ok
next

func decimaltobase(nr,base)
     binList = []
     binary = 0
     remainder = 1
     while(nr != 0)
          remainder = nr % base
          ind = find(decList,remainder)
          rem = baseList[ind]
          add(binList,rem)
          nr = floor(nr/base)
     end
     binlist = reverse(binList)
     binList = list2str(binList)
     binList = substr(binList,nl,"")
     return binList
