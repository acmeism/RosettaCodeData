newtype Mu a = Roll { unroll :: Mu a -> a }

fix :: (a -> a) -> a
fix = \f -> (\x -> f (unroll x x)) $ Roll (\x -> f (unroll x x))

fac :: Integer -> Integer
fac = fix $ \f n -> if (n <= 0) then 1 else n * f (n-1)

fibs :: [Integer]
fibs = fix $ \fbs -> 0 : 1 : fix zipP fbs (tail fbs)
  where zipP f (x:xs) (y:ys) = x+y : f xs ys

main = do
  print $ map fac [1 .. 20]
  print $ take 20 fibs
