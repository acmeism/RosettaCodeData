import Data.List

dv :: Floating a => a -> a -> a
dv = (. sqrt). (*)

fy t = 1/16 * (4+t^2)^2

rk4 :: (Enum a, Fractional a)=> (a -> a -> a) -> a -> a -> a -> [(a,a)]
rk4 fd y0 a h = zip ts $ scanl (flip fc) y0 ts  where
  ts = [a,h ..]
  fc t y = sum. (y:). zipWith (*) [1/6,1/3,1/3,1/6]
    $ scanl (\k f -> h * fd (t+f*h) (y+f*k)) (h * fd t y) [1/2,1/2,1]

task =  mapM_ print
  $ map (\(x,y)-> (truncate x,y,fy x - y))
  $ filter (\(x,_) -> 0== mod (truncate $ 10*x) 10)
  $ take 101 $ rk4 dv 1.0 0 0.1
