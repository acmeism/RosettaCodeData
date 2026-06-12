load "stdlib.ring"

see "working..." + nl
see "Numbers < 200 whose binary and ternary digit sums are prime:" + nl

decList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
baseList = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]

num = 0
limit = 200

for n = 1 to limit
    strBin = decimaltobase(n,2)
    strTer = decimaltobase(n,3)
    sumBin = 0
    for m = 1 to len(strBin)
        sumBin = sumBin + number(strBin[m])
    next
    sumTer = 0
    for m = 1 to len(strTer)
        sumTer = sumTer + number(strTer[m])
    next
    if isprime(sumBin) and isprime(sumTer)
       num = num + 1
       see "" + num + ". {" + n + "," + strBin + ":" + sumBin + "," + strTer + ":" + sumTer + "}" + nl
    ok
next

see "Found " + num + " such numbers" + nl
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
