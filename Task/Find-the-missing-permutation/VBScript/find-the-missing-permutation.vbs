arrp = Array("ABCD", "CABD", "ACDB", "DACB", "BCDA", "ACBD",_
      "ADCB", "CDAB", "DABC", "BCAD", "CADB", "CDBA",_
      "CBAD", "ABDC", "ADBC", "BDCA", "DCBA", "BACD",_
      "BADC", "BDAC", "CBDA", "DBCA", "DCAB")

Dim col(4)

'supposes that a complete column have 6 of each letter.
target = (6*Asc("A")) + (6*Asc("B")) + (6*Asc("C")) + (6*Asc("D"))

missing = ""

For i = 0 To UBound(arrp)
	For j = 1 To 4
            col(j) = col(j) + Asc(Mid(arrp(i),j,1))
	Next
Next

For k = 1 To 4
	n = target - col(k)
	missing = missing & Chr(n)
Next

WScript.StdOut.WriteLine missing
