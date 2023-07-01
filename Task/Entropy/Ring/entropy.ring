decimals(8)
entropy = 0
countOfChar = list(255)

source="1223334444"
charCount  =len( source)
usedChar  =""

for i =1 to len( source)
     ch =substr(source, i, 1)
     if not(substr( usedChar, ch)) usedChar =usedChar +ch ok
     j  =substr( usedChar, ch)
    countOfChar[j] =countOfChar[j] +1
next

l =len(usedChar)
for i =1 to l
     probability =countOfChar[i] /charCount
     entropy =entropy - (probability *logBase(probability, 2))
next

see "Characters used and the number of occurrences of each " + nl
for i =1 to l
      see "'" + substr(usedChar, i, 1) + "' " + countOfChar[i] + nl
next

see " Entropy of " + source + " is  " + entropy + " bits." + nl
see " The result should be around 1.84644 bits." + nl

func logBase (x, b)
        logBase =log( x) /log( 2)
        return logBase
