import Control.Arrow (second)
import Data.Bool (bool)

narcissiOfLength :: Int -> [Int]
narcissiOfLength nDigits = snd <$> go nDigits []
  where
    powers = ((,) <*> (^ nDigits)) <$> [0 .. 9]
    go n parents =
      bool
        (filter (isDaffodil nDigits . snd) parents)
        (go
           (pred n)
           (bool
              (parents >>=
               (\(d, pwrSum) -> (second (pwrSum +) <$> take (succ d) powers)))
              powers
              (null parents)))
        (0 < n)

isDaffodil :: Int -> Int -> Bool
isDaffodil e n =
  (((&&) . (e ==) . length) <*> (n ==) . powerSum e) (digitList n)

powerSum :: Int -> [Int] -> Int
powerSum n = foldr ((+) . (^ n)) 0

digitList :: Int -> [Int]
digitList 0 = [0]
digitList n = go n
  where
    go 0 = []
    go x = rem x 10 : go (quot x 10)


-- TEST ----------------------------------------------------------------------

main :: IO ()
main =
  putStrLn $
  fTable
    "Narcissistic decimal numbers of length 1-7:\n"
    show
    show
    narcissiOfLength
    [1 .. 7]

fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  let rjust n c = drop . length <*> (replicate n c ++)
      w = maximum (length . xShow <$> xs)
  in unlines $
     s : fmap (((++) . rjust w ' ' . xShow) <*> ((" -> " ++) . fxShow . f)) xs
