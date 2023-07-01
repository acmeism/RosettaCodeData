see "The first 100 tau numbers are:" + nl + nl

n = 1
num = 0
limit = 100
while num < limit
      n = n + 1
      tau = 0
      for m = 1 to n
          if n%m = 0
             tau = tau + 1
          ok
      next
      if n%tau = 0
         num = num + 1
         if num%10 = 1
            see nl
         ok
         see "" + n + " "
      ok
end
