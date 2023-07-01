basePlus = []
decList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
baseList = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]

see "working..." + nl

for base = 2 to 10
for n = 1 to 40000
    basePlus = []
    nrPow = pow(n,2)
    str = decimaltobase(nrPow,base)
    ln = len(str)
    for m = 1 to ln
        nr = str[m]
        ind = find(baseList,nr)
        num = decList[ind]
        add(basePlus,num)
    next
    flag = 1
    basePlus = sort(basePlus)
    if len(basePlus) = base
       for p = 1 to base
           if basePlus[p] = p-1
              flag = 1
           else
              flag = 0
              exit
           ok
       next
       if flag = 1
          see "in base: " + base + " root: " + n + " square: " + nrPow + " perfect square: " + str + nl
          exit
       ok
     ok
next
next
see "done..." + nl

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
