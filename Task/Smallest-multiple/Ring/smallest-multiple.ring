see "working..." + nl
see "Smallest multiple is:" + nl
n = 0

while true
      n++
      flag = 0
      for m = 1 to 20
          if n % m = 0
             flag += 1
          ok
      next
      if flag = 20
         see "" + n + nl
         exit
      ok
end

see "done..." + nl
