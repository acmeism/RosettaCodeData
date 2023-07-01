see "The tau functions for the first 100 positive integers are:" + nl

n = 0
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
      num = num + 1
      if num%10 = 1
         see nl
      ok
      tau = string(tau)
      if len(tau) = 1
         tau = " " + tau
      ok
      see "" + tau + " "
end
