symbols = "MDCLXVI"
weights = [1000,500,100,50,10,5,1]

see "MCMXCIX = " + romanDec("MCMXCIX") + nl
see "MDCLXVI =" + romanDec("MDCLXVI") + nl
see "XXV = " + romanDec("XXV") + nl
see "CMLIV = " + romanDec("CMLIV") + nl
see "MMXI = " + romanDec("MMXI") + nl

func romanDec roman
     n = 0
     lastval = 0
     arabic = 0
     for i = len(roman) to 1 step -1
         n = substr(symbols,roman[i])
         if n > 0 n = weights[n] ok
         if n < lastval arabic = arabic - n
         else arabic = arabic + n ok
         lastval = n
     next
     return arabic
