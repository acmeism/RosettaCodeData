fib 0 = 0 -- this line is necessary because "something ^ 0" returns "fromInteger 1", which unfortunately
          -- in our case is not our multiplicative identity (the identity matrix) but just a 1x1 matrix of 1
fib n = last $ head $ unMat $ (Mat [[1,1],[1,0]]) ^ n
