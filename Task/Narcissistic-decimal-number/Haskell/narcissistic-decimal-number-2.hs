import Control.Arrow (second)

isDaffodil :: Int -> Int -> Bool
isDaffodil e n =
  let ds = digitList n
  in e == length ds && n == powerSum e ds

powerSum :: Int -> [Int] -> Int
powerSum n = foldr ((+) . (^ n)) 0

digitList :: Int -> [Int]
digitList 0 = []
digitList n = rem n 10 : digitList (quot n 10)

narcissiOfLength :: Int -> [Int]
narcissiOfLength nDigits = snd <$> digitTree nDigits []
  where
    powers = ((,) <*> (^ nDigits)) <$> [0 .. 9]
    digitTree n parents =
      if n > 0
        then digitTree -- Power sums for all unordered digit combinations.
               (n - 1) -- (Digit order is irrelevant when summing powers)
               (if null parents
                  then powers
                  else concatMap
                         (\(d, pwrSum) ->
                             (second (pwrSum +) <$> take (d + 1) powers))
                         parents)
        else filter (isDaffodil nDigits . snd) parents

main :: IO ()
main = print $ 0 : concatMap narcissiOfLength [1 .. 7]
