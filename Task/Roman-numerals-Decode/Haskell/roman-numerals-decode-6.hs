import qualified Data.Map.Strict as M

fromRoman :: String -> Int
fromRoman xs = partialSum + lastDigit
  where
    (partialSum, lastDigit) = foldl accumulate (0, 0) (evalRomanDigit <$> xs)
    accumulate (partial, lastDigit) newDigit
      | newDigit <= lastDigit = (partial + lastDigit, newDigit)
      | otherwise = (partial - lastDigit, newDigit)

mapRoman :: M.Map Char Int
mapRoman =
  M.fromList
    [ ('I', 1)
    , ('V', 5)
    , ('X', 10)
    , ('L', 50)
    , ('C', 100)
    , ('D', 500)
    , ('M', 1000)
    ]

evalRomanDigit :: Char -> Int
evalRomanDigit c =
  let mInt = M.lookup c mapRoman
  in case mInt of
       Just x -> x
       _ -> error $ c : " is not a roman digit"

main :: IO ()
main = print $ fromRoman <$> ["MDCLXVI", "MCMXC", "MMVIII", "MMXVI", "MMXVII"]
