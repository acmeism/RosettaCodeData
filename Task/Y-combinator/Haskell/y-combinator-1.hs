newtype Mu a = Roll
  { unroll :: Mu a -> a }

fix :: (a -> a) -> a
fix = g <*> (Roll . g)
  where
    g = (. (>>= id) unroll)

fac :: Integer -> Integer
fac =
  fix $
  \f n ->
     (if n <= 0
        then 1
        else n * f (n - 1))

fibs :: [Integer]
fibs =
  fix $ (0 :) . (1 :) . (fix (\f (x:xs) (y:ys) -> x + y : f xs ys) <*> tail)

main :: IO ()
main =
  mapM_
    print
    [ map fac [1 .. 20]
    , take 20 fibs
    ]
