import Data.List (intercalate, maximumBy)
import Data.Ord (comparing)

task1 = mapM_ run [43 % 48, 5 % 121, 2014 % 59]
  where
    run x = putStrLn $ show x ++ " = " ++ result x
    result x = intercalate " + " $ show <$> egyptianFraction x

task21 n =
  maximumBy
    (comparing snd)
    [ (a % b, length $ egyptianFraction (a % b))
    | a <- [1 .. n]
    , b <- [1 .. n]
    , a < b ]

task22 n =
  maximumBy
    (comparing snd)
    [ (a % b, maximum $ map denominator $ egyptianFraction (a % b))
    | a <- [1 .. n]
    , b <- [1 .. n]
    , a < b ]
