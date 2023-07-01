see "working..." + nl
see "First 19 circular numbers are:" + nl
n = 0
row = 0
Primes = []

while row < 19
      n++
      flag = 1
      nStr = string(n)
      lenStr = len(nStr)
      for m = 1 to lenStr
          leftStr = left(nStr,m)
          rightStr = right(nStr,lenStr-m)
          strOk = rightStr + leftStr
          nOk = number(strOk)
          ind = find(Primes,nOk)
          if ind < 1 and strOk != nStr
             add(Primes,nOk)
          ok
          if not isprimeNumber(nOk) or ind > 0
             flag = 0
             exit
          ok
       next
       if flag = 1
          row++
          see "" + n + " "
          if row%5 = 0
             see nl
          ok
       ok
end

see nl + "done..." + nl

func isPrimeNumber(num)
     if (num <= 1) return 0 ok
     if (num % 2 = 0) and (num != 2) return 0 ok
     for i = 2 to sqrt(num)
	 if (num % i = 0) return 0 ok
     next
     return 1
