# Project : Square but not cube

limit = 30
num = 0
sq = 0
while num < limit
      sq = sq + 1
      sqpow = pow(sq,2)
      flag = iscube(sqpow)
      if flag = 0
         num = num + 1
         see sqpow + nl
      else
         see "" + sqpow + " is square and cube" + nl
      ok
end

func iscube(cube)
     for n = 1 to cube
         if pow(n,3) = cube
            return 1
         ok
     next
     return 0
