decimals(8)
array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
see "arithmetic mean = "  + arithmeticMean(array) + nl
see "geometric mean =  "  + geometricMean(array) + nl
see "harmonic mean =  "  + harmonicMean(array) + nl

func arithmeticMean a
     return summary(a) / len(a)

func geometricMean a
     b = 1
     for i = 1 to len(a)
         b *= a[i]
     next
     return pow(b, (1/len(a)))

func harmonicMean a
     b = list(len(a))
     for nr = 1 to len(a)
         b[nr] = 1/a[nr]
     next
     return len(a) / summary(b)

func summary s
     sum = 0
     for n = 1 to len(s)
         sum += s[n]
     next
     return sum
