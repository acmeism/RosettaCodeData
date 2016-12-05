n = 0
count = 0
size = 15
while count != size
      m = isNarc(n)
      if m=1 see "" + n + " is narcisstic" + nl
         count = count + 1 ok
      n = n + 1
end

func isNarc n
     m = len(string(n))
     sum = 0
     digit = 0
     for pos = 1 to m
         digit = number(substr(string(n), pos, 1))
         sum = sum + pow(digit,m)
     next
     nr = (sum = n)
     return nr
