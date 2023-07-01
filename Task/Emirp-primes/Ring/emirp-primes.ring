nr = 1
m = 2
see "first 20 :" + nl
while nr < 21
      emirp = isEmirp(m)
      if emirp = 1 see m see " "
         nr++ ok
      m++
end
see nl + nl

nr = 1
m = 7701
see "between 7700 8000 :" + nl
while m > 7700 and m < 8000
      emirp = isEmirp(m)
      if emirp = 1 see m see " " nr++ ok
      m++
end
see nl + nl

nr = 1
m = 2
see "Nth 10000 :" + nl
while nr > 0 and nr < 101
      emirp = isEmirp(m)
      if emirp = 1 nr++ ok
      m++
end
see m + nl

func isEmirp n
     if not isPrime(n) return false ok
     cStr = string(n)
     cstr2 = ""
     for x = len(cStr) to 1 step -1 cStr2 += cStr[x] next
     rev = number(cstr2)
     if rev = n return false ok
     return isPrime(rev)

func isPrime n
     if n < 2 return false ok
     if n < 4 return true ok
     if n % 2 = 0 return false ok
     for d = 3 to sqrt(n) step 2
         if n % d = 0 return false ok
     next
     return true
