load "stdlib.ring"
see "working..." + nl
see "Numbers in base 10 that are palindromic in bases 2, 4, and 16:" + nl

row = 0
limit = 25000

for n = 1 to limit
    base2 = decimaltobase(n,2)
    base4 = decimaltobase(n,4)
    base16 = hex(n)
    bool = ispalindrome(base2) and ispalindrome(base4) and ispalindrome(base16)
    if bool = 1
       see "" + n + " "
       row = row + 1
       if row%5 = 0
          see nl
       ok
    ok
next

see nl + "Found " + row + " numbers" + nl
see "done..." + nl

func decimaltobase(nr,base)
     decList = 0:15
     baseList = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]

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
