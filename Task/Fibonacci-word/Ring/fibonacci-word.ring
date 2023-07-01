# Project : Fibonacci word

fw1 = "1"
fw2 = "0"

see "N   Length  Entropy                Word" + nl
n = 1
see "" + n + "      " + len(fw1) + "           " + calcentropy(fw1,2) + "      " + fw1 + nl
n = 2
see "" + n + "      " + len(fw2) + "           " + calcentropy(fw2,2) + "      " + fw2 + nl

for n = 1 to 55
      fw3 = fw2 + fw1
      temp = fw2
      fw2 = fw3
      fw1 = temp
      if len(fw3) < 55
         see "" + (n+2) + "      " + len(fw3) + "          " + calcentropy(fw3,2) + "     " + fw3 + nl
      ok
next

func calcentropy(source,b)
        decimals(11)
        entropy = 0
        countOfChar = list(255)
        charCount  =len( source)
        usedChar  =""
        for i =1 to len( source)
             ch =substr(source, i, 1)
             if not(substr( usedChar, ch))
                usedChar =usedChar +ch
             ok
             j  =substr( usedChar, ch)
            countOfChar[j] =countOfChar[j] +1
        next
        l =len(usedChar)
        for i =1 to l
             probability =countOfChar[i] /charCount
             entropy =entropy - (probability *logBase(probability, 2))
        next
        return entropy

func swap(a, b)
        temp = a
        a = b
        b = temp
        return [a, b]

func logBase (x, b)
        logBase =log( x) /log( 2)
        return logBase
