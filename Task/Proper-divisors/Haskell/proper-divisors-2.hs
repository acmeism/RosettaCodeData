import Data.List (maximumBy)
import Data.Ord (comparing)
import Data.Bool (bool)

properDivisors
  :: Integral a
  => a -> [a]
properDivisors n =
  let root = (floor . sqrt . fromIntegral) n
      lows = filter ((0 ==) . rem n) [1 .. root]
  in init (lows ++ bool id tail (n == root * root) (reverse (quot n <$> lows)))

main :: IO ()
main = do
  putStrLn "Proper divisors of 1 to 10:"
  mapM_ (print . properDivisors) [1 .. 10]
  mapM_
    putStrLn
    [ ""
    , "A number in the range 1 to 20,000 with the most proper divisors,"
    , "as (number, count of proper divisors):"
    , ""
    ]
  print $
    maximumBy (comparing snd) $
    (,) <*> (length . properDivisors) <$> [1 .. 20000]
