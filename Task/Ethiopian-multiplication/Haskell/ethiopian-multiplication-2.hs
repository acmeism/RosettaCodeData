import Data.List (inits, intercalate, unfoldr)
import Data.Tuple (swap)
import Debug.Trace (trace)

----------------- ETHIOPIAN MULTIPLICATION ---------------

ethMult :: Int -> Int -> Int
ethMult n m =
  ( trace
      =<< (<> "\n")
        . ((showDoubles pairs <> " = ") <>)
        . show
  )
    (foldr addedWhereOdd 0 pairs)
  where
    pairs = zip (unfoldr halved n) (iterate doubled m)
    doubled x = x + x
    halved h
      | 0 < h =
        Just $
          trace
            (showHalf h)
            (swap $ quotRem h 2)
      | otherwise = Nothing

    addedWhereOdd (d, x) a
      | 0 < d = (+) a x
      | otherwise = a

---------------------- TRACE DISPLAY ---------------------

showHalf :: Int -> String
showHalf x = "halve: " <> rjust 6 ' ' (show (quotRem x 2))

showDoubles :: [(Int, Int)] -> String
showDoubles xs =
  "double:\n"
    <> unlines (go <$> xs)
    <> intercalate " + " (xs >>= f)
  where
    go x
      | 0 < fst x = "-> " <> rjust 3 ' ' (show $ snd x)
      | otherwise = rjust 6 ' ' $ show $ snd x
    f (r, q)
      | 0 < r = [show q]
      | otherwise = []

rjust :: Int -> Char -> String -> String
rjust n c s = drop (length s) (replicate n c <> s)

--------------------------- TEST -------------------------
main :: IO ()
main = do
  print $ ethMult 17 34
  print $ ethMult 34 17
