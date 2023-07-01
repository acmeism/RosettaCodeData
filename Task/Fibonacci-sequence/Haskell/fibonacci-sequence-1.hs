import Data.CReal

phi = (1 + sqrt 5) / 2

fib :: (Integral b) => b -> CReal 0
fib n = (phi^^n - (-phi)^^(-n))/sqrt 5
