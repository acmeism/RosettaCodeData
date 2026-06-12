load "stdlib.ring"

decList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
baseList = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]

see "working..." + nl
see "Numbers whose base 2 representation is the juxtaposition of two identical strings:" + nl

row = 0
limit1 = 1000

for n = 1 to limit1
    bin = decimaltobase(n,2)
    ln = len(bin)
    if ln & 1 = 0
       if left(bin,ln/2) = right(bin,ln/2)
          row++
          see sfl(n, 3) + " (" + sfrs(bin, 10) + ")  "
          if row % 5 = 0 see nl ok
       ok
     ok
next

? nl + "Found " + row + " numbers whose base 2 representation is the juxtaposition of two identical strings"
? "done..."

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

# a very plain string formatter, intended to even up columnar outputs
def sfrs x, y
    l = len(x)
    x += "            "
    if l > y y = l ok
    return substr(x, 1, y)

# a very plain string formatter, intended to even up columnar outputs
def sfl x, y
    s = string(x) l = len(s)
    if l > y y = l ok
    return substr("          ", 11 - y + l) + s
