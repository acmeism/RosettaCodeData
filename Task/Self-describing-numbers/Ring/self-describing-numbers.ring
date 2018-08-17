# Project : Self-describing numbers

for num = 1 to 45000000
     res = 0
     for n=1 to len(string(num))
          temp = string(num)
          pos = number(temp[n])
          cnt = count(temp,string(n-1))
          if cnt = pos
             res = res + 1
          ok
      next
      if res = len(string(num))
         see num + nl
      ok
next

func count(cString,dString)
       sum = 0
       while substr(cString,dString) > 0
               sum = sum + 1
               cString = substr(cString,substr(cString,dString)+len(string(sum)))
       end
       return sum
